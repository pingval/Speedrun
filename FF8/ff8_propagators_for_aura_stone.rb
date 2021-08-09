# -*- encoding: utf-8 -*-

$option = {
  N: 1000000,
}

Propagator_Battle = 16.0

# 普通に
Yellow2_Red1 = 21.0
Red1_Red2 = 22.5

# 赤1前セーブ
Yellow2_Save_Red1 = 30.0
Red2_Reset_Red1 = 44.0

# 赤2前黄
Red1_Yellow = 24.5
Yellow_Red1 = 21.5

def got?(color = :red)
  r = rand(256)
  n = case color
  when :red; 178
  when :purple; 11
  else 0
  end
  n > r
end

def straight
  got = false
  time = 0.0

  time += Yellow2_Red1
  time += Propagator_Battle; got ||= got?
  time += Red1_Red2
  time += Propagator_Battle; got ||= got?
  [got, time]
end

def save_before_red1
  got = false
  time = 0.0

  time += Yellow2_Save_Red1
  loop {
    time += Propagator_Battle; got ||= got?
    time += Red1_Red2
    time += Propagator_Battle; got ||= got?
    break if got

    time += Red2_Reset_Red1
  }
  [got, time]
end

def yellow_before_red2
  got = false
  time = 0.0
  time += Yellow2_Red1

  loop {
    time += Propagator_Battle; got ||= got?
    if got
      time += Red1_Red2
      time += Propagator_Battle; got ||= got?
      break
    end
    time += Red1_Yellow
    time += Propagator_Battle
    time += Yellow_Red1
  }
  [got, time]
end

FNS = [:straight, :save_before_red1, :yellow_before_red2]

def main
  FNS.each{|fn|
    h = Hash.new 0
    got_sum = time_sum = 0
    $option[:N].times{
      got, time = send(fn)
      got_sum += 1 if got
      time_sum += time
      h[time] += 1
    }
    puts "* #{fn}"
    puts "%-20s%.2f%%"%["Aura Stone Rate", got_sum.fdiv($option[:N])*100]
    p 
    puts "%-20s%.1fs"%["Average Loss", time_sum.fdiv($option[:N])]
    puts "  Distribution:"
    h.sort.each{|time, count|
      puts "  %6.1fs%10.2f%%"%[time, count.fdiv($option[:N])*100]
    }
    puts "----"
  }
end

main()

