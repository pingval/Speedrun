# -*- encoding: utf-8 -*-

Stat_abbrs = %w[mhp str vit mag spr spd luck].map(&:intern)

Ally_stat_values_tbl = {
  squall: [
    [44, 255, 179, 0],
    [30, 5, 2, 38],
    [26, 5, 5, 41],
    [28, 4, 6, 39],
    [24, 5, 5, 41],
    [0, 5, 20, 30],
    [0, 7, 15, 14],
    [0, 0, 250, 0],
    [11, 0, 100, 0],
  ],
  zell: [
    [42, 255, 210, 0],
    [29, 5, 7, 39],
    [23, 5, 4, 42],
    [24, 2, 3, 40],
    [20, 6, 0, 46],
    [0, 5, 20, 20],
    [0, 8, 14, 16],
    [3, 0, 250, 0],
    [14, 0, 100, 0],
  ],
  irvine: [
    [41, 255, 172, 0],
    [28, 22, 5, 46],
    [22, 6, 5, 43],
    [27, 4, 5, 38],
    [22, 4, 1, 38],
    [0, 4, 19, 20],
    [0, 8, 13, 24],
    [10, 0, 250, 1],
    [15, 0, 100, 0],
  ],
  quistis: [
    [41, 255, 175, 0],
    [29, 6, 5, 40],
    [21, 4, 4, 43],
    [26, 4, 5, 42],
    [24, 10, 8, 42],
    [0, 5, 19, 20],
    [0, 7, 14, 14],
    [255, 255, 250, 1],
    [19, 0, 100, 0],
  ],
  rinoa: [
    [44, 255, 173, 0],
    [38, 6, 3, 39],
    [19, 5, 2, 57],
    [29, 5, 30, 57],
    [21, 2, 10, 44],
    [0, 5, 20, 25],
    [0, 8, 16, 16],
    [16, 0, 250, 1],
    [16, 0, 100, 0],
  ],
  selphie: [
    [39, 255, 172, 0],
    [28, 6, 3, 42],
    [20, 5, 3, 46],
    [24, 5, 20, 60],
    [23, 4, 8, 46],
    [0, 4, 15, 28],
    [0, 6, 18, 12],
    [21, 0, 100, 0],
    [17, 0, 100, 0],
  ],
  seifer: [
    [60, 255, 215, 0],
    [30, 5, 10, 36],
    [25, 5, 8, 42],
    [26, 5, 9, 46],
    [20, 2, 18, 44],
    [0, 3, 15, 30],
    [0, 7, 12, 14],
    [27, 0, 250, 1],
    [18, 0, 100, 0],
  ],
  edea: [
    [40, 255, 169, 0],
    [26, 7, 0, 46],
    [10, 7, 0, 150],
    [28, 5, 44, 41],
    [24, 3, 30, 41],
    [0, 5, 16, 20],
    [0, 10, 10, 20],
    [31, 0, 250, 0],
    [20, 0, 100, 0],
  ],
  laguna: [
    [44, 255, 140, 0],
    [30, 5, 5, 38],
    [26, 5, 5, 41],
    [28, 5, 6, 41],
    [24, 5, 5, 41],
    [0, 5, 22, 20],
    [0, 7, 14, 14],
    [35, 0, 250, 0],
    [21, 0, 100, 0],
  ],
  kiros: [
    [40, 255, 120, 0],
    [28, 5, 4, 38],
    [22, 5, 5, 42],
    [30, 5, 7, 40],
    [26, 5, 6, 41],
    [0, 5, 30, 35],
    [0, 6, 15, 12],
    [39, 0, 250, 0],
    [22, 0, 100, 0],
  ],
  ward: [
    [50, 255, 160, 0],
    [33, 5, 8, 38],
    [25, 5, 10, 48],
    [25, 5, 6, 38],
    [22, 5, 3, 41],
    [0, 6, 15, 24],
    [0, 12, 10, 24],
    [255, 255, 255, 255],
    [0, 0, 0, 0],
  ]
}

def ally_stat(char, lv, stat_abbr)
  char = char.intern.downcase
  stat_id = Stat_abbrs.index(stat_abbr)
  
  v = Ally_stat_values_tbl[char][stat_id]
  
  case stat_abbr
  when :mhp
    r = lv*v[0] - lv*lv*10/v[1] + v[2]
  when :str, :vit, :mag, :spr
    r = (lv*v[0]*0x66666667 >> 34) - (lv*v[0] >> 31) + lv/v[1] + v[2] - ((lv*lv/v[3] + (lv*lv/v[3] >> 31)) >> 1)
    r += 3 if r < 0           # これなくても結果は一緒みたいだけど
    r >>= 2
  when :spd, :luck
    r = lv*v[0] + lv/v[1] + v[2] - lv/v[3]
  end
  r
end

Ally_stat_values_tbl.keys.each {|char|
  puts "* " + char.to_s.capitalize
  puts %w[LV MHP STR VIT MAG SPR SPD LUCK].join("\t")
  
  (1..100).each {|lv|
    stats = Stat_abbrs.map{|abbr|
      ally_stat(char, lv, abbr)
    }
    puts ([lv] + stats).join("\t")
  }
  puts "----"
}
