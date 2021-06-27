# -*- encoding: utf-8 -*-
#
# 2016/06/04
# ・$option[:card_succ3_range]を追加
# ・加えてデフォルトの範囲を1..3から1..4へ変更
# ・psff8_field_rndをクラス化し、変数名のrndをrngへ変更
# 2016/06/02
# ・公開

$option = {
  # 探索の基準とするindex　RTAで無駄がないと350付近らしい
  default_start_index: 350,
  
  # Base+カード戦オフセットを中央として、これだけの幅を探索
  search_width: 200,
  
  # 検索順 反転:reverse, 降順:ascending, 昇順:descending, 通常:それ以外
  search_order: :reverse,
  
  # キスカ1ツモ固定かつゼルカなし(カード戦闘数の入力を飛ばす)
  beginning_quistis_card_only: false,
  
  # 直前にハードリセットを行う(カード戦闘数の入力を飛ばす)…探索する意味ねえ
  hardware_reset: false,
  
  # 乱数の消費数が3であるカード戦闘数の範囲(てきとう)
  card_succ3_range: 1..4,
  
  # 電柱のセット数上限
  poles_arr_size: 5,
  
  debug: false,
  language: :ja,
}
# ハードリセットを行うと乱数のインデックスが初期化される
$option[:default_start_index] = 8 if $option[:hardware_reset]

# STDIN.getch用
require "io/console"

# ワイルドカードを表すTrueClass的なクラス
class WildCardClass
  def to_s; "*"; end
  def inspect; "*"; end
end
WildCard = WildCardClass.new

=begin
NPC_Station_Table = { "0" => :none, "1" => :walk, }
NPC_Escalator_Table = { "0" => :none, "1" => :boy, "2" => :girl, "3" => :both, }
NPC_Street_Table = { "0" => :none, "1" => :walk, "2" => :still_walk, }
NPC_Bus_Table = { "0" => :none, "1" => :appear, "2" => :stop, "3" => :leave, }
=end
NPC_Station_Table = { "1" => :none, "2" => :walk, }
NPC_Escalator_Table = { "1" => :both, "2" => :boy, "3" => :girl, "4" => :none, }
NPC_Street_Table = { "1" => :walk, "2" => :none, "3" => :still_walk, }
NPC_Bus_Table = { "1" => :none, "2" => :appear, "3" => :stop, "4" => :leave, }

# 基本、キスカ・ゼルカ戦闘数は必要
if ARGV.size < ($option[:hardware_reset] || $option[:beginning_quistis_card_only]  ? 1 : 3)
  puts <<__EOF__
Usage: #{File.basename(__FILE__, ".*")} Qcard Zcard [poles+] [NPCs]
Qcard	キスティスカード戦闘数
Zcard	ゼルカード戦闘数
poles	電車の奥、窓越しに見える電柱の数(2,3秒間隔)
NPCs	以下の値を繋げた文字列
  station	デリングシティ駅右下のNPC
		#{NPC_Station_Table.map{|k, v| k + v.inspect }.join(", ")}
  escalator	エスカレータ右下のNPC
		#{NPC_Escalator_Table.map{|k, v| k + v.inspect }.join(", ")}
  street	道に出たところのNPC
		#{NPC_Street_Table.map{|k, v| k + v.inspect }.join(", ")}
  bus		カーウェイ邸前左下のNPC
		#{NPC_Bus_Table.map{|k, v| k + v.inspect }.join(", ")}
poles~busの値に0~9以外の文字("-"など)を指定するとどのパターンにもマッチする。
※"*"はRubyが受け取る前にワイルドカード展開されてしまうので使用できない。
Press any key to continue...
__EOF__

  STDIN.getch()
  puts <<__EOF__
e.g.
・rnd[353]: code:"178"
  Qcard:1, Zcard:0, poles:[1, 10, 3, 7]
  train:walk, escalator:both, street:walk, bus:leave
    #{File.basename(__FILE__, ".*")} 1 0 1 10 3 7 2114
  ・見逃したものがある場合、"-"などで置換すればよい。
    電柱2セット目とバスNPCを見逃した場合：
      #{File.basename(__FILE__, ".*")} 1 0 1 - 3 7 211-
  ・poles+ のみや NPCs のみの指定も可能：
      #{File.basename(__FILE__, ".*")} 1 0 1 10 3 7
      #{File.basename(__FILE__, ".*")} 1 0 2114
・rnd[351]: code:"139"
  Qcard:1, Zcard:0, poles:[15, 6, 1, ?],
  train:none, escalator:both, street:walk, bus:stop
  電柱4セット目を最後まで確認することができないため、"-"を入力：
    #{File.basename(__FILE__, ".*")} 1 0 15 6 1 - 1113
__EOF__
  exit
end

puts "$option\t#{$option}" if $option[:debug]
puts "ARGV\t#{ARGV}" if $option[:debug]

def str_arr2poles_arr(str_arr)
  r = str_arr.last($option[:poles_arr_size]).map{|s|
    s =~ /\A\d+\Z/ ? s.to_i : WildCard
  }
  # 足りない分は先頭からWildCardで埋める
  [WildCard]*($option[:poles_arr_size] - r.size) + r
end

def str2npc_val(str, hash)
  h = hash.clone
  h.default = WildCard
  h[str]
end

# 最後の引数の文字列長が4以上なら最後の引数をNPC指定と見做す
deling_npcs = ARGV[-1].size < 4 ? "----" : ARGV.pop
$args_for_search = {
  quistis_card: \
  if $option[:hardware_reset]
    0
  elsif $option[:beginning_quistis_card_only]
    1
  else
    ARGV.shift.to_i
  end,
  zell_card: \
  if $option[:hardware_reset] || $option[:beginning_quistis_card_only]
    0
  else
    ARGV.shift.to_i
  end,
  poles_arr:    str_arr2poles_arr(ARGV[0..-1]),
  station:      str2npc_val(deling_npcs[0], NPC_Station_Table),
  escalator:    str2npc_val(deling_npcs[1], NPC_Escalator_Table),
  street:       str2npc_val(deling_npcs[2], NPC_Street_Table),
  bus:          str2npc_val(deling_npcs[3], NPC_Bus_Table),
}

# PS版FF8のフィールド(？)乱数の状態
class FF8_Field_RNG
  Initial_State = 0x0000_0001
  attr_accessor :state
  
  def initialize(seed=Initial_State)
    @state = seed
  end
  
  def next_state
    @state = (@state * 0x41c6_4e6d + 0x3039) & 0xffff_ffff
  end
  
  # 乱数生成を行う rand(0..32767)
  def nxt
    (next_state() >> 16) & 0x7fff
  end
  
  # 乱数の状態の上位2バイト目を返す rand(0..255)
  def next_1b
    nxt() & 0x00ff
  end
end

# カーウェイ邸番号を求めるためのテーブルを構築する
def make_caraway_code_table(from, to)
  # 乱数の状態 to+10はマージンを余分目にみて
  rng = FF8_Field_RNG.new
  rng_state_arr = Array.new(to+10) {
    r = rng.state
    rng.next_state
    r
  }
  
  # 実際に使用された乱数(0..255)
  source_arr = rng_state_arr.map {|v| (v >> 16) & 0xff }
  
  (0..to).map{|idx|
    next nil if !idx.between?(from, to) # 0...fromは生成しない
    # source
    source = source_arr[idx]
    
    # code
    code = "%03d" % case source
    when 0 then 1
    when 1..199 then source
    else source - 199
    end
    
    # 電柱の数はrand(0..255) % 16
    poles_min_idx = idx - ($option[:poles_arr_size] + 3)
    poles_arr =
    if poles_min_idx < 0
      nil
    else
      source_arr[poles_min_idx..idx-4].map{|v| v % 16 }
    end
    
    # 駅NPC
    station =
    if idx-3 < 0
      nil
    else
      source_arr[idx-3] >= 100 ? :none : :walk
    end
    
    # エスカレータNPC
    escalator =
    if idx-2 < 0
      nil
    elsif source_arr[idx-2] >= 150
      source_arr[idx-1] >= 150 ? :none : :boy
    else
      source_arr[idx-1] >= 150 ? :girl : :both
    end
    
    # 道NPC
    street =
    if source_arr[idx+1] >= 120
      if source_arr[idx+1] >= 200
        source_arr[idx+3] >= 130 ? :still_walk : :none
      else
        :none
      end
    else
      :walk
    end
    
    # バスNPC
    bus =
    if source_arr[idx+1] >= 200
      if source_arr[idx+6] < 200
        if source_arr[idx+4] >= 100
          source_arr[idx+5] >= 100 ? :appear : :stop
        else
          source_arr[idx+5] >= 100 ? :stop : :leave
        end
      else
        :none
      end
    elsif source_arr[idx+4] < 200
      if source_arr[idx+2] >= 100
        source_arr[idx+3] >= 100 ? :appear : :stop
      else
        source_arr[idx+3] >= 100 ? :stop : :leave
      end
    else
      :none
    end
    
    {
      index: idx,               # 配列のインデックス
      rng_state: "%08x" % [rng_state_arr[idx]], # 乱数の状態
      source: source,           # codeの元となる値
      code: code,               # カーウェイ邸番号
      poles_arr: poles_arr,     # 電柱の数の配列
      station: station,         # 駅NPC
      escalator: escalator,     # エスカレータNPC
      street: street,           # 道NPC
      bus: bus,                 # バスNPC
      # 入力コマンド
      input: code.reverse.scan(/\d/).map{|c|
        up, down, as_is, open, close =
        if $option[:language] == :ja
          %w[↑ ↓ 侭 【 】]
        else
          %w[up down as-is \[ \]]
        end
        n = c.to_i
        next "#{c}#{open}#{as_is}#{close}" if n.zero?
        direction = n <= 5 ? down : up
        count = n <= 5 ? n : 10 - n
        "#{c}#{open}#{direction}#{count.abs == 1 ? '' : count}#{close}"
      }.join(", ")
    }
  }
end

def caraway_code_match?(pattern, code_data)
  target = [
  *code_data[:poles_arr],
  code_data[:station],
  code_data[:escalator],
  code_data[:street],
  code_data[:bus]
  ]
  matchp = pattern.zip(target).all?{|a, b|
    if b.nil?                   # 対象がnil: マッチしない
      false
    elsif a == WildCard         # パターンがワイルドカード: 何にでもマッチ
      true
    else                        # それ以外は普通に比較
      a == b
    end
  }
  if matchp || $option[:debug]
    rng_state = $option[:debug] ? "#{code_data[:rng_state]}→" : ""
    puts "%s\t[%03d] %s%03d→\"%s\" %s" % [matchp ? "*match*" : "", code_data[:index], rng_state, code_data[:source], code_data[:code], target]
  end
  matchp
end

# カーウェイ邸の番号を探索する
def search_caraway_code(quistis_card:1, zell_card:0, poles_arr:[], station: :none, escalator: :none, street: :none, bus: :none)
  # カード戦n-1回目まで:+3、n回目以降:+6とする(実際はこれよりも上下にブレる)
  def card2offset(battles)
    1.upto(battles).map{|n|
      $option[:card_succ3_range].include?(n) ? 3 : 6
    }.inject(:+) || 0
  end
  # キスティスカードのオフセット
  quistis_card_offset = card2offset(quistis_card)
  # ゼルカードのオフセット
  zell_card_offset = card2offset(zell_card)
  # 探索開始地点
  start_index = $option[:default_start_index] + quistis_card_offset + zell_card_offset
  # 探索パターン
  pattern = [*poles_arr, station, escalator, street, bus]
  puts "pattern = #{pattern}"
  
  # 探索順(インデックスの配列)
  order = ([start_index] + 1.upto($option[:search_width] / 2).map{|offset|
    [start_index + offset, start_index - offset]
  }).flatten.select{|idx|
    idx >= 0
  }
  case $option[:search_order]
  when :reverse    then order.reverse!
  when :ascending  then order.sort!
  when :descending then order.sort!.reverse!
  end
  
  # 必要なだけテーブルを構築
  code_table = make_caraway_code_table(order.min, order.max)
  # 探索
  order.map{|idx|
    code_data = code_table[idx]
    if caraway_code_match?(pattern, code_data)
      {
        diff: idx - start_index, # 探索開始地点との差分
        index: idx,             # インデックス
        code_data: code_data,
      }
    end
  }.compact
end

def main
  puts <<__EOF__
Quistis card	#{$args_for_search[:quistis_card]} battle(s)
Zell card	#{$args_for_search[:zell_card]} battle(s)
poles count	#{$args_for_search[:poles_arr]}
station NPC	#{$args_for_search[:station].inspect}
ecalator NPC	#{$args_for_search[:escalator].inspect}
street NPC	#{$args_for_search[:street].inspect}
bus NPC		#{$args_for_search[:bus].inspect}

__EOF__

  r = search_caraway_code($args_for_search)
  puts "#{r.empty? ? "not" : r.size} found."
  return if r.empty?
  
  puts ""
  # 開始地点に最も近いインデックス
  nearest_index = r.min_by{|v| v[:diff].abs }[:index]
  puts "diff\tindex\tcode\tinput"
  r.each{|v|
    diff, idx, code_data = v.values
    nearestp = idx == nearest_index
    idx_str = (nearestp ? "*[%03d]*" : "[%03d]") % [idx]
    puts "%+4d\t%s\t\"%s\"\t%s" % [diff, idx_str, code_data[:code], code_data[:input]]
  }
end

main()
