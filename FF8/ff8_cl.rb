# -*- encoding: utf-8 -*-
# 2016/06/19
# ・CL1..4以外はCL1..4を分母とする(できる)よう、denominator_256_pオプションを追加

$option = {
  per: 100,
  denominator_256_p: false,
  default_args: {
    # hp: nil,
    mhp: 1000,
    dead: 0,
    st: [],
    seiferp: false,
  },
  conditions: [
    { dead: 0, },
    { dead: 1, },
    { dead: 2, },
    { dead: 0, st: [:aura], },
    { dead: 1, st: [:aura], },
    { dead: 2, st: [:aura], },
    { dead: 0, seiferp: true, },
    { dead: 1, seiferp: true, },
    { dead: 2, seiferp: true, },
  ],
}

CL_Result_Table = {
  cl1:   1,
  cl2:   2,
  cl3:   3,
  cl4:   4,
  cl1_4: 1..4,
}

def crisis_level(hp: 1, mhp: 9999, dead: 0, st: [], seiferp: false)
  st_mod_tbl = {
    aura: 200,
    slow: 15,
    poison: 30,
    blind: 30,
    silence: 30,
    slow_petrify: 30,
    doom: 45,
  }
  st_mod_tbl.default = 0
  
  hp_mod = ((seiferp ? 1000 : 2500) * hp / mhp).floor
  death_bonus = dead * 200 + 1600
  # st = [st] if !st.is_a?(Array)
  st_bonus = (st.uniq.map{|s| st_mod_tbl[s] }.inject(:+) || 0) * 10
  
  ll_arr = (0..255).map{|rnd|
    random_mod = rnd + 160
    (st_bonus + death_bonus - hp_mod) / random_mod
  }
  cl_arr = ll_arr.map{|ll|
    [[4, ll].max, 8].min - 4
  }
  cl_arr
end

def cl_arr2result(cl_arr)
  cl_arr.inject(Hash[CL_Result_Table.keys.map{|k| [k, 0] }]){|r, cl|
    CL_Result_Table.each{|k, val_or_range|
      r[k] += 1 if val_or_range === cl
    }
    r
  }
end

def main(cond)
  args_for_cl = $option[:default_args].merge(cond)
  hp_arr = (0..$option[:per]).map{|i|
    args_for_cl[:mhp] * i / $option[:per]
  }
  
  puts args_for_cl
  puts ["HP", "HP rate", "CL 1", "CL 2", "CL 3", "CL 4", "CL 1..4"].join("\t")
  hp_arr.each{|hp|
    cl_arr = crisis_level(**args_for_cl.merge({ hp: hp }))
    r = cl_arr2result(cl_arr)
    
    puts "%d\t%f\t%f\t%f\t%f\t%f\t%f" % [
      hp, hp.fdiv(args_for_cl[:mhp]),
    *(CL_Result_Table.keys.map{|k|
      denominator = \
      if k == :cl1_4 || $option[:denominator_256_p]
        cl_arr.size
      else
        r[:cl1_4]
      end
      r[k].fdiv(denominator)
    })
    ]
  }
end

$option[:conditions].each{|cond|
  main(cond)
}
