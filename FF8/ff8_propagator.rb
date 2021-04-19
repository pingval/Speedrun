# -*- encoding: utf-8 -*-

$option = {
  number: 1000000,
  colors: [:purple, :green, :red, :orange].map{|c| [c, c]}.flatten,
  borders: {
    aura: [1, 2],
  }
}
$option[:borders].default = [1]

Propagator_Drop_Table = {
  purple: {
    rate: 192,
    items: [:shell, :protect, :aura, :death],
  },
  green:  {
    rate: 192,
    items: [:death, :holy, :ultima, :ultima],
  },
  red:    {
    rate: 255,                  # 赤のみ(255+1)/256=100%!
    items: [:aura, :death, :ultima, :ultima],
  },
  orange: {
    rate: 192,
    items: [:flare, :meteor, :ultima, :ultima],
  },
}

Stone_Name_Table = {
  shell:   "シェル",
  protect: "プロテス",
  aura:    "オーラ",
  death:   "デス",
  holy:    "ホーリー",
  flare:   "フレア",
  meteor:  "メテオ",
  ultima:  "アルテマ",
  none:    "(なし)",
}

R = Hash[Stone_Name_Table.keys.map{|stone| [stone, 0] }]

# 戦闘乱数
class FF8_Battle_RNG
  include Enumerable
  
  attr_accessor :index
  attr_accessor :true_rand
  
  RND_ARR = <<__RNG__.split(/\s+/).map(&:hex)
63 06 F0 23 F8 E5 A8 01 C1 AE 7F 48 7B B1 DC 09
22 6D 7D EE 9D 58 D5 55 24 39 7A DF 8E 54 6C 1B
C0 0B D0 43 D8 9A 47 5D 21 02 17 4B DB 11 AF 70
CD 4D 34 49 72 91 2D 62 97 59 45 F7 6E 46 AA 0A
A3 C8 31 92 38 FA D4 E6 CB F3 DE 6B BB F1 1C 3C
D6 AD B2 A9 DD 57 42 95 0C 79 25 1F BC E7 AC 5B
83 28 76 F2 18 DA 87 A1 61 6F BE 5A 5E 51 EF B0
C9 15 74 89 BD D1 A2 75 D7 99 85 4C 4F D2 BF 4A
20 08 56 A0 50 3A 67 26 41 33 B7 BA FB 30 CF 7C
84 2C 32 E9 1D 16 82 78 A4 80 65 5F 0E 27 B9 19
C3 A7 B6 00 3B FC 88 E1 C6 93 FE 8B D9 B8 13 69
2F 64 12 37 FD 77 E2 B5 04 E0 1A 8C 8F B4 CC F9
60 EB 29 E3 90 A5 68 3D 81 73 3F AB 7E B3 0F CE
C4 35 94 96 86 71 D3 2A E4 9F 9C EC 4E 14 F5 EA
40 A6 F6 03 98 C5 07 F4 2B C2 3E E8 9B 36 53 2E
8D 0D 52 10 66 1E ED 8A 44 9E 05 FF 5C C7 6A CA
__RNG__
  
  def initialize(seed=0)
    init(seed)
    @true_rand = false
  end
  
  def init(seed=nil)
    @index = seed.nil? ? rand(0..0xff) : seed % 256
  end
  
  def shuffle
    init()
  end
  
  def get
    return rand(0..0xff) if @true_rand
    r = RND_ARR[@index]
    @index += 1
    @index = 0 if @index >= 256
    r
  end
  
  alias next_1b get
  
  def each
    Enumerator.new{|y|
      loop { y << get }
    }.lazy.each {|rnd|
      yield rnd
    }
  end
end

def dropped?(n)
  n + 1 > $rng.get()
end

def drop_slot
  rnd = $rng.get()
  case rnd
  when 0..177 then 0
  when 178..228 then 1
  when 229..243 then 2
  when 244..255 then 3
  end
end

def drop(color)
  rate = Propagator_Drop_Table[color][:rate]
  if dropped?(rate)
    slot = drop_slot()
    Propagator_Drop_Table[color][:items][slot]
  else
    :none
  end
end

def drop_per_one(color)
  number = 256
  border = 1
  r = R.clone
  number.times {|i|
    # ドロップ判定・スロット判定のみ連続
    # 0..255について1回ずつ
    $rng.init(i)
    stone = drop(color)
    r[stone] += 1
  }

  sum = 0
  above_border_count = 0
  r.each {|stone, num|
    next if num.zero?
    puts "%s\t%.2f%%\t%d/%d" % [stone, num.fdiv(number)*100, num, number]
  
    sum += num
    above_border_count += num if num >= border
  }
=begin
  puts "平均\t%.2f" % sum.fdiv(number)
  puts "%d以上\t%.2f%%\t%d/%d" % [border, above_border_count.fdiv(number)*100, above_border_count, number]
=end
  puts "試行\t%d" % number
end

def drop_colors(colors: [:red], number: 10000, borders: {})
  r = Hash[Stone_Name_Table.keys.map{|stone| [stone, []] }]
  number.times {
    rr = R.clone
    colors.each{|color|
      # ドロップ判定・スロット判定のみ連続
      $rng.shuffle()
      stone = drop(color)
      rr[stone] += 1
    }
    rr.each{|stone, num|
      r[stone][num] ||= 0
      r[stone][num] += 1
    }
  }
  
  r.each {|stone, num_arr|
    next if stone == :none
    next if num_arr.empty?
    
    puts Stone_Name_Table[stone]
    sum = 0
    border_count_h = Hash[borders[stone].map{|border| [border, 0]}]
    num_arr.each_with_index{|cnt, num|
      next if cnt.nil?
      puts "%d\t%.2f%%" % [num, cnt.fdiv(number)*100]
      
      sum += num * cnt
      border_count_h.each{|border, _|
        border_count_h[border] += cnt if num >= border
      }
    }
    puts "平均\t%.2f" % sum.fdiv(number)
    
    border_count_h.each{|border, count|
      puts "%d以上\t%.2f%%" % [border, count.fdiv(number)*100]
    }
    #puts "試行\t%d" % number
    puts ""
  }
  puts "試行\t%d" % number
end

$rng = FF8_Battle_RNG.new

Propagator_Drop_Table.keys.each{|color|
  puts "* %s" % [color.capitalize]
  drop_per_one(color)
  puts "----"
}
puts "* %s" % [$option[:colors].map(&:capitalize).map(&:to_s).join(", ")]
drop_colors($option)
