# -*- encoding: utf-8 -*-
#
# 2016/10/26
# ・English is supported (with "language: :en")
# ・実際の通しで2800台が多かったため、baseのデフォルト値を2500から2800に変更
# ・パターンの表現に用いる文字を"urdl"から"8624"へ変更
# ・「待機時間」を「延長時間」に変更
# ・ヘルプがちょっとだけ詳しくなった
# 2016/06/24
# ・公開、したあとちょっと更新

require "set"
# require "tapp"

$option = {
  # 言語 日本語:ja, English:en
  language: :en,
  
  # 目標とするパーティ。複数設定可能。
  targets: [
    %i[irvine zell selphie],
    %i[irvine zell quistis],
    %i[selphie irvine quistis],
  ],
  # これらも同じ意味
  # targets: %w[Ir,Ze,Se Ir,Ze,Qu Ir,Se,Qu],
  # targets: %w[アゼセ アゼキ アセキ],
  
  # 探索の基準とするindex
  base: 2800,
  
  # baseを中央として、これだけの幅を探索
  width: 2000,
  
  # 検索順 反転:reverse, 降順:ascending, 昇順:descending, 通常:それ以外
  order: :reverse,
  
  # 直前でハードリセットを行う(DISC4開始データ)
  hardware_reset: false,
  
  # アデル後ムービー乱数カウンタを使用する
  adel_rnd_counter: true,
  
  # 最終マップ乱数カウンタを使用する
  last_map_rnd_counter: true,
  
  # 最終マップを最速で進んだ場合の空回し継続時間
  # ps2fast_ja:22.0, ps2fast_na:22.7?
  last_map_duration: 22.0,
  
  # last_map_duration % 0.5 がこの範囲内なら最終マップで待機しない
  last_map_safe_range: 0.10..0.40,
  
  # 入力に使用できる文字。初期設定ではテンキー/wasd/ijklが使える
  input: {
    up:    %w[8 w i],
    down:  %w[2 s k],
    left:  %w[4 a j],
    right: %w[6 d l],
    # ワイルドカード。[]を指定した場合は↑以外の全てがワイルドカード扱いになる
    any:   %w[],
  },
  
  # スコールの動き上限
  movements_size: 12,
  
  # 見出しの横幅
  left_width: 40,
  
  # fps
  console_fps: 60,
  
  debug: false,
  fallback_language: :en,
}

# モジュール化してみた
module FF8
  # フィールド乱数
  class Field_RNG < Enumerator::Lazy
    # include Enumerable

    Initial_State = 0x0000_0001
    attr_reader :state, :seed
    attr_accessor :true_rand, :enum_method

    def initialize(seed=Initial_State, enum_method: :get, true_rand: false)
      init(seed)
      @enum_method = enum_method
      @true_rand = true_rand
    end

    def init(seed=nil)
      @seed = (seed.nil? ? rand(0..0xffff_ffff) : seed)
      @state = @seed
    end

    def shuffle
      init
    end

    def next_state
      return rand(0..0xffff_ffff) if @true_rand
      # @state = (@state * 0x41c6_4e6d + 0x3039) & 0xffff_ffff
      @state.tap {
        @state = (@state * 0x41c6_4e6d + 0x3039) & 0xffff_ffff
      }
    end

    # 乱数生成を行う rand(0..32767)
    def nxt
      (next_state >> 16) & 0x7fff
    end

    # 乱数の状態の上位2バイト目を返す rand(0..255)
    def next_1b
      nxt() & 0x00ff
    end
    alias get next_1b

    def each
      return to_enum if !block_given?
      
      Enumerator.new {|y|
        loop { y << self.send(@enum_method) }
      }.each {|rnd|
        yield rnd
      }
    end

    def peek
      _state = @state
      self.send(@enum_method).tap { @state = _state }
    end

    def size
      Float::INFINITY
    end

    def rewind
      # @state = Initial_State
      @state = @seed
    end
  end
  
  # パーティ
  class Party < Set
    Char_Str_Table = {
      squall:  "Sq",
      zell:    "Ze",
      irvine:  "Ir",
      quistis: "Qu",
      rinoa:   "Ri",
      selphie: "Se",
    }
    
    def self.x2char(x)
      case x
      when 0, :sq, :squall , /\A(Sq|ス)/i then :squall
      when 1, :ze, :zell   , /\A(Ze|ゼ)/i then :zell
      when 2, :ir, :irvine , /\A(Ir|ア)/i then :irvine
      when 3, :qu, :quistis, /\A(Qu|キ)/i then :quistis
      when 4, :ri, :rinoa  , /\A(Ri|リ)/i then :rinoa
      when 5, :se, :selphie, /\A(Se|セ)/i then :selphie
      end
    end
    
    def self.char2str(c)
      Char_Str_Table[c]
    end
    
    def initialize(str_or_arr = nil, &block)
      party = case str_or_arr
      when String
        str_or_arr.scan(/Sq|ス|Ze|ゼ|Ir|ア|Qu|キ|Ri|リ|Se|セ/i).map {|s|
          Party::x2char(s)
        }
      when Array
        str_or_arr.map{|x| Party::x2char(x) }
      else
        nil
      end
      return if party.nil?
      super(party.compact.first(3), &block)
    end

    def inspect
      to_a.sort_by {|c|
        %i[squall zell irvine rinoa selphie quistis].index(c)
      }.values_at(1, 0, 2).map {|c|
        c.nil? ? "__" : Party::char2str(c)
      }.join(",")
    end
    alias to_s inspect

    def include?(x)
      super(Party::x2char(x))
    end

    def add(x)
      super(Party::x2char(x))
    end

    def delete(x)
      super(Party::x2char(x))
    end
  end
end

include FF8

# from http://d.hatena.ne.jp/zariganitosh/20140926/japanese_ljust_rjust_center
begin
  class String
    def full_length() count("^ -~｡-ﾟ") end
    def length_ja() length + full_length end
    def ljust_ja(width, padstr=' ') align_ja(:ljust, width, padstr) end
    def rjust_ja(width, padstr=' ') align_ja(:rjust, width, padstr) end
    def center_ja(width, padstr=' ') align_ja(:center, width, padstr) end

    def align_ja(method, width, padstr, dummy='A'*length_ja)
      if full_length == 0
        send(method, width, padstr)
      else
        dummy.succ!.empty? && break while padstr.include?(dummy)
        dummy.send(method, width, padstr).sub(dummy, self)
      end
    end
  end
end

# i18n的な
String_Resources = {
  ja: {
#     fallback_test: "ふぉーるばっくてすと",
    targets_of_party: "目標パーティ",
    search_range: "探索範囲",
    sojourn_and_extra: "最終マップ滞在 + 延長時間",
    party_selection_offset: "パーティ選定オフセット",
    pattern: "スコールの動きのパターン",
    extra_last_map: "最終マップ延長時間",
    prompt: {
      adel_rng_counter: "Enterを押せばムービー乱数カウンタを開始します(再びEnterを押せば終了)...",
      last_map_rng_counter: "Enterを押せば最終マップ乱数カウンタを開始します(再びEnterを押せば終了)...",
    },
    help: <<__EOF__,
Usage: #{File.basename(__FILE__, ".*")} [any] movements
any	ハードリセットを行う
これ以外のオプションは全て、$option変数から設定してください。

e.g.
・ノーリセ通し時の入力一例：
  #{File.basename(__FILE__, ".*")} 848264444444
  or #{File.basename(__FILE__, ".*")} wawsdaaaaaaa
  or #{File.basename(__FILE__, ".*")} ijikljjjjjjj
・DISC4開始データ使用(ハードリセット指定)：
  #{File.basename(__FILE__, ".*")} 0 666468426882
  or #{File.basename(__FILE__, ".*")} hoge dddadwasdwws
  or #{File.basename(__FILE__, ".*")} hage llljlijkliik
  ・1,2,5,12番目を見逃した場合：
    #{File.basename(__FILE__, ".*")} 0 006408426880
    # 見逃した動きの代わりに「8426/wasd/ijkl」以外の文字を入力
__EOF__
  },
  en: {
    fallback_test: "fallbacktest",
    targets_of_party: "Targets of Party",
    search_range: "Search Range",
    sojourn_and_extra: "Sojourn and Extra Time at the Last Map",
    party_selection_offset: "Party Selection Offset",
    pattern: "Squall's Movements Pattern",
    extra_last_map: "Extra Time at the Last Map",
    prompt: {
      adel_rng_counter: "press Enter to start FMV RNG Counter (and press Enter again to stop)...",
      last_map_rng_counter: "press Enter to start Last Map RNG Counter (and press Enter again to stop)...",
    },
    help: <<__EOF__,
Usage: #{File.basename(__FILE__, ".*")} [any] movements
any	perform Hardware Reset
Please configure all options other than this with $option variable.

e.g.
- An example of actual run with no resets:
  #{File.basename(__FILE__, ".*")} 848264444444
  or #{File.basename(__FILE__, ".*")} wawsdaaaaaaa
  or #{File.basename(__FILE__, ".*")} ijikljjjjjjj
- From the beginning of DISC 4 (with Hardware Reset option):
  #{File.basename(__FILE__, ".*")} 0 666468426882
  or #{File.basename(__FILE__, ".*")} hoge dddadwasdwws
  or #{File.basename(__FILE__, ".*")} hage llljlijkliik
  - If you missed 1st, 2nd, 5th and 12th movement:
    #{File.basename(__FILE__, ".*")} 0 006408426880
    # instead of missed movements, input any char except "8426/wasd/ijkl".
__EOF__
  },
}
T = $option[:language].tap{|lang|
  break (String_Resources[lang] || {}).merge({
  })
}
# i18n.t的な
def t(s)
  f = lambda{|string_resource, keys|
    keys.inject(string_resource){|h, k| h.fetch(k, {})}
  }
  keys = s.split(".").map{|k|
    # keyが数字なら配列のindexとして扱う
    k =~ /\A\d+\Z/ ? k.to_i : k.intern
  }
  r = f.(T, keys)
  if r == {}
    # 見つからなければfallback_languageを適用
    r = f.(String_Resources[$option[:fallback_language]], keys)
  end
  r == {} ? s : r
end

# 最終パーティ選定
def last_party(rnd)
  tbl = [
    [0, 1, 2], [0, 1, 4], [0, 1, 5], [0, 1, 3], [0, 2, 4],
    [0, 2, 5], [0, 2, 3], [0, 4, 5], [0, 4, 3], [0, 5, 3],
    [1, 2, 4], [1, 2, 5], [1, 2, 3], [1, 4, 5], [1, 4, 3],
    [1, 5, 3], [2, 4, 5], [2, 4, 3], [2, 5, 3], [4, 5, 3],
  ]
  idx = rnd.floor / 13
  Party.new(tbl[idx])
end

def make_last_party_table(from, to)
  # かなり余裕をみて
  margin = 250
  size = to + margin
  # 乱数の状態
  rng_state_arr = Field_RNG.new(enum_method: :next_state).first(size)
  # 実際に使用された乱数(0..255)
  source_arr = Field_RNG.new.first(size)
  # スコールの動く方向
  direction_arr = source_arr.map {|v|
    %i[8 2 4 6][v & 3]
  }
  # 最終マップを最速で進んだ場合のパーティ
  party_arr = Array.new(size - $option[:party_rnd_offset]) {|i|
    last_party(source_arr[i + $option[:party_rnd_offset]])
  }
  # 最も近い目標までのオフセットテーブルの配列
  target_offset_tbl_arr = lambda {|arr|
    r = []
    arr.reverse.each_with_index {|curr_party, i|
      r[i] = i.zero? ? {} : Hash[r[i - 1].map {|k, v| [k, v + 1] }]
      r[i][curr_party] = 0 if $option[:targets].include?(curr_party)
    }
    r.reverse
  }.(party_arr)
  
  (0..to).map{|idx|
    next nil if !idx.between?(from, to) # 0...fromは生成しない
    r = {
      index: idx,
      # source
      source: source_arr[idx],
      # 乱数の状態
      rng_state: "%08x" % [rng_state_arr[idx]],
      # party
      party: party_arr[idx],
      # movements
      movements: lambda {|arr|
        first = [0, idx - ($option[:movements_size] - 1)].max
        last = idx
        arr[first..last].map(&:to_s).join("")
      }.(direction_arr),
      # 目標パーティまでのオフセット
      target_offset_tbl: Hash[$option[:targets].map{|target_party|
        [target_party, target_offset_tbl_arr[idx][target_party]]
      }],
    }
    r[:nearest_target] = r[:target_offset_tbl].min_by{|k, v| v}.first
    r
  }
end

# 正規表現を使ってマッチ
def last_party_match?(pattern, data)
  matchp = data[:movements] =~ pattern
  matchp.tap {
    if matchp || $option[:debug]
      rng_state = $option[:debug] ? "%s " % [data[:rng_state]] : ""
      puts "%s\t[%04d] %s\"%s\" %s" % [matchp ? "*match*" : "", data[:index], rng_state, data[:movements], data[:target_offset_tbl]
      ]
    end
  }
end

# 目標のパーティを探索する
def search_last_party(pattern)
  # 探索開始地点
  start_index = $option[:base]

  # 探索順(インデックスの配列)
  order = ([start_index] + 1.upto($option[:width] / 2).map{|offset|
    [start_index + offset, start_index - offset]
  }).flatten.select{|idx|
    idx >= 0
  }
  order.delete(order.max) if $option[:width].even?
  
  case $option[:order]
  when :reverse    then order.reverse!
  when :ascending  then order.sort!
  when :descending then order.sort!.reverse!
  end
  
  # 必要なだけテーブルを構築
  table = make_last_party_table(order.min, order.max)
  # 探索
  order.map{|idx|
    data = table[idx]
    if last_party_match?(pattern, data)
      {
        diff: idx - start_index, # 探索開始地点との差分
        index: idx,             # インデックス
        data: data,
      }
    end
  }.compact
end

# 正規表現をつかう
def str2pattern(s)
  pat = s.chars.map {|c|
    case c
    when *$option[:input][:up]    then "8"
    when *$option[:input][:down]  then "2"
    when *$option[:input][:left]  then "4"
    when *$option[:input][:right] then "6"
    else
      if $option[:input][:any].nil? || $option[:input][:any].empty?
        "."
      elsif $option[:input][:any].include?(c)
        "."
      end
    end
  }.compact.last($option[:movements_size]).join("") + "$"
  Regexp.new(pat)
end

# オプションをちょこまか弄る
def modify_options
  # 引数が2以上の場合、ハードリセットを行うものとする
  if ARGV.size > 1
    ARGV.shift                  # よくないかなー
    $option[:hardware_reset] = true
  end
  
  # ハードリセットを行うと乱数が初期化される
  $option[:base] = 15 if $option[:hardware_reset]
  
  # 目標パーティ
  $option[:targets].map! {|x| Party.new(x) }.uniq
  
  rem = $option[:last_map_duration] % 0.5
  # 最終マップで延長すべき時間
  $option[:last_map_extra] = \
  if $option[:last_map_safe_range].cover?(rem)
    0
  elsif rem < $option[:last_map_safe_range].min
    0.25 - rem
  else
    0.75 - rem
  end
  # 直前の乱数から最終パーティ選定に適用される乱数までのオフセット
  $option[:party_rnd_offset] = (($option[:last_map_duration] + $option[:last_map_extra]) / 0.5).floor + 1
end

def show_help
  puts t("help")
end

# フレームカウンタ
def frame_counter(period=60, max: nil, fps: 30)
  start = Time.now.to_f
  puts "count\tframe"
  f = lambda {
    duration = Time.now.to_f - start
    frame = (duration * 60).floor
    count = frame.quo(period).floor
    curr_frame = (frame % period).floor
    print "%d\t%3d/%d\r" % [count, curr_frame, period]
    if !max.nil?
      break if count >= max
    end
  }
  
  loop { f.(); sleep(1.quo(fps)) }
end

# アデル後ムービー乱数カウンタ
def adel_rnd_counter(max=45)
  frame_counter(101, max: max, fps: $option[:console_fps])
end

# 最終マップ乱数カウンタ
def last_map_rnd_counter
  # 延長時間込み。精度は大丈夫？
  print "(wait %.2fs)\r" % [$option[:last_map_extra]]
  sleep($option[:last_map_extra])
  frame_counter(30, fps: $option[:console_fps])
end

def main
  # 引数がなければヘルプを表示して終了
  if ARGV.empty?
    show_help()
    exit
  end
  
  modify_options()
  pattern = str2pattern(ARGV.shift)
  
  # 再計算してるのがアレだな
  from = [0, $option[:base] - $option[:width] / 2].max
  to =   [0, $option[:base] + ($option[:width].fdiv(2)).ceil - 1].max
  
  width = $option[:left_width]
  puts t("targets_of_party").ljust_ja(width) + "#{$option[:targets]}"
  puts t("search_range").ljust_ja(width) + "#{from..to}"
  puts t("sojourn_and_extra").ljust_ja(width) + "#{"%.2f + %.2fs" % [$option[:last_map_duration], $option[:last_map_extra]]}"
  puts t("party_selection_offset").ljust_ja(width) + "#{$option[:party_rnd_offset]}"
  puts t("pattern").ljust_ja(width) + "#{pattern.inspect}"
  
  r = search_last_party(pattern)
  
  puts "#{r.empty? ? "not" : r.size} found."
  return if r.empty?
  
  puts ""
  # 開始地点に最も近いインデックス 絶対値が等しいなら若い方
  nearest_index = r.min_by{|v| [v[:diff].abs, v[:diff]] }[:index]
  # targetsの分だけヘッダを作る
  offsets_header = r.first[:data][:target_offset_tbl].keys.map{|k|
    "%10s" % [k]
  }.join("")
  puts "diff\tlastidx\t" + offsets_header
  
  r.each{|v|
    diff, idx, data = v.values
    nearestp = idx == nearest_index
    idx_str = (nearestp ? "*[%04d]" : "[%04d]") % [idx]
    offsets = data[:target_offset_tbl].map{|k, v|
      # p data[:nearest_target]
      fmt = k == data[:nearest_target] ? "* %+d *" : "%+d  "
      r = fmt % [v]
      " "*(10 - r.size) + r
    }.join("")
    puts "%+4d\t%s\t%s" % [diff, idx_str, offsets]
  }
  puts ""
  extra_s = $option[:last_map_extra].zero? ? "none" : "%.2fs" % [$option[:last_map_extra]]
  puts "%s = %s" % [t("extra_last_map"), extra_s]
  
  if $option[:adel_rnd_counter]
    print t("prompt.adel_rng_counter")
    STDIN.gets &&  t = Thread.new { adel_rnd_counter(26) }
    STDIN.gets &&  t.kill
    puts ""
  end
  
  if $option[:last_map_rnd_counter]
    print t("prompt.last_map_rng_counter")
    STDIN.gets && t = Thread.new { last_map_rnd_counter() }
    STDIN.gets && t.kill
  end
end

main()
