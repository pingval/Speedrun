# -*- encoding: utf-8 -*-
# フォカロルフェイクのヒレドロップ数を計算
# 戦闘乱数がドロップ判定→スロット判定と連続で使用される点を考慮

$option = {
  number: 100000,
  border_arr: [4,5],
  battle_times_range: 1..6,
}

class Battle_RNG
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
  @@index = 0
  
  def self.init(seed)
    @@index = seed % 256
  end
  
  def self.shuffle()
    self.init(rand(0..255))
  end
  
  def self.get
    # return rand(0..255)
    r = RND_ARR[@@index]
    @@index += 1
    @@index = 0 if @@index >= 256
    r
  end
end

def drop_slot()
  rnd = Battle_RNG::get()
  case rnd
  when 0..177 then 0
  when 178..228 then 1
  when 229..243 then 2
  when 244..255 then 3
  end
end

def dropped?(n)
  n + 1 > Battle_RNG::get()
end

def get_fins()
  return 0 if !dropped?(192)
  [1, 1, 2, 3][drop_slot()]
end

def calc_fins_per_one()
  number = 256
  border = 1
  r = []
  number.times {|i|
    # ドロップ判定・スロット判定のみ連続
    # 0..255について1回ずつ
    Battle_RNG::init(i)
    num = get_fins()
    r[num] ||= 0
    r[num] += 1
  }

  sum = 0
  above_border_count = 0
  r.each_with_index {|cnt, num|
    next if cnt.nil?
    puts "%d\t%.2f%%\t%d/%d" % [num, cnt.fdiv(number)*100, cnt, number]
  
    sum += num * cnt
    above_border_count += cnt if num >= border
  }
  puts "平均\t%.2f" % sum.fdiv(number)
  puts "%d以上\t%.2f%%\t%d/%d" % [border, above_border_count.fdiv(number)*100, above_border_count, number]
  puts "試行\t%d" % number
end

def calc_fins(enemies, number=10000, border=5)
  r = []
  number.times {
    num = Array.new(enemies) {
      # ドロップ判定・スロット判定のみ連続
      Battle_RNG::shuffle()
      get_fins()
    }.inject(&:+)
    r[num] ||= 0
    r[num] += 1
  }

  sum = 0
  border_count_h = Hash[$option[:border_arr].map{|border| [border, 0]}]
  r.each_with_index {|cnt, num|
    next if cnt.nil?
    puts "%d\t%.2f%%" % [num, cnt.fdiv(number)*100]
  
    sum += num * cnt
    border_count_h.each {|border, _|
      border_count_h[border] += cnt if num >= border
    }
  }
  puts "平均\t%.2f" % sum.fdiv(number)
  border_count_h.each {|border, count|
    puts "%d以上\t%.2f%%" % [border, count.fdiv(number)*100]
  }
  puts "試行\t%d" % number
end

puts "* 1匹"
calc_fins_per_one()
puts "----"

$option[:battle_times_range].each{|battle_times|
  puts "* %d戦"  % battle_times
  calc_fins(battle_times * 2, $option[:number], $option[:border])
  puts "----"
}
