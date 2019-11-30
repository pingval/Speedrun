# usage: psff8_stepid_manip.rb ENCOUNTER_COUNT_LIMIT WALKING_COUNT_LIMIT TARGET_DISTANCE

# search conditions
ENCOUNTER_COUNT_LIMIT = ARGV[0] ? ARGV[0].to_i : 19
WALKING_COUNT_LIMIT = ARGV[1] ? ARGV[1].to_i : 20
TARGET_DISTANCE = ARGV[2] ? ARGV[2].to_i : 830

# constants
RUNNING_DANGER_VALUE = 5
WALKING_DANGER_VALUE = 2
# approximate ratio: running : walking ≒ 3 : 1
RUNNING_DISTANCE = 3
WALKING_DISTANCE = 1

DANGER_LIMITS = [7, 182, 240, 31, 85, 91, 55, 227, 174, 79, 178, 94, 153, 246, 119, 203, 96, 143, 67, 62, 167, 76, 45, 136, 199, 104, 215, 209, 194, 242, 193, 221, 170, 147, 22, 247, 38, 4, 54, 161, 70, 78, 86, 190, 108, 110, 128, 213, 181, 142, 164, 158, 231, 202, 206, 33, 255, 15, 212, 140, 230, 211, 152, 71, 244, 13, 21, 237, 196, 228, 53, 120, 186, 218, 39, 97, 171, 185, 195, 125, 133, 252, 149, 107, 48, 173, 134, 0, 141, 205, 126, 159, 229, 239, 219, 89, 235, 5, 20, 201, 36, 44, 160, 60, 68, 105, 64, 113, 100, 58, 116, 124, 132, 19, 148, 156, 150, 172, 180, 188, 3, 222, 84, 220, 197, 216, 12, 183, 37, 11, 1, 28, 35, 43, 51, 59, 151, 27, 98, 47, 176, 224, 115, 204, 2, 74, 254, 155, 163, 109, 25, 56, 117, 189, 102, 135, 63, 175, 243, 251, 131, 10, 18, 26, 34, 83, 144, 207, 122, 139, 82, 90, 73, 106, 114, 40, 88, 138, 191, 14, 6, 162, 253, 250, 65, 101, 210, 77, 226, 92, 29, 69, 30, 9, 17, 179, 95, 41, 121, 57, 46, 42, 81, 217, 93, 166, 234, 49, 129, 137, 16, 103, 245, 169, 66, 130, 112, 157, 146, 87, 225, 61, 241, 249, 238, 8, 145, 24, 32, 177, 165, 187, 198, 72, 80, 154, 214, 127, 123, 233, 118, 223, 50, 111, 52, 168, 208, 184, 99, 200, 192, 236, 75, 232, 23, 248]

def make_danger_limit_table(output = false)
  cycle = 0
  stepid = 0
  offsync = 0
  danger_limit_table = []
  offsync_table = []
  (256 ** 2).times{|idx|
    danger_limit = (DANGER_LIMITS[stepid] + offsync) & 0xff
    danger_limit_table << danger_limit
    if output
      puts [idx, cycle, offsync, stepid, danger_limit] * "\t"
    end

    stepid = (stepid + 1) & 0xff
    if stepid == 0
      cycle += 1
      offsync = (offsync + 13) & 0xff
    end
  }
  danger_limit_table
end
DANGER_LIMIT_TABLE = make_danger_limit_table()

def min_encounter_search(start_stepidx = 0)
  q = []
  # distance, walking_count, stepidx, encounter_history, walking_history
  q << [0, 0, start_stepidx, [0], [0]]

  ok = false
  enc_cnt = 0
  # breadth first search algorithm
  while !q.empty? && !ok && enc_cnt <= ENCOUNTER_COUNT_LIMIT
    new_q = []
    q.each{|dist, walk_cnt, stepidx, enc_his, walk_his, dv = 0|
      # run until an encounter occurs
      while dv <= DANGER_LIMIT_TABLE[stepidx % 65536]
        stepidx += 1
        dv += RUNNING_DANGER_VALUE
        dist += RUNNING_DISTANCE
        enc_his << 0
        walk_his << 0
      end
      ok = true if dist - 1 >= TARGET_DISTANCE

      new_enc_his = enc_his.dup
      new_enc_his[-1] = 1
      new_walk_his = walk_his.dup
      new_elem = [dist, walk_cnt, stepidx, new_enc_his, new_walk_his]
      # replace item if better state
      idx = new_q.index{|_dist, _walk_cnt, _stepidx, _enc_his, _walk_his|
        stepidx == _stepidx && dist >= _dist && walk_cnt <= _walk_cnt
      } || new_q.size
      new_q[idx] = new_elem

      # redo if current encounter can be erased by walking
      walkable_step = enc_his.size - 1 - [(enc_his.rindex(1) || -1), (walk_his.rindex(1) || -1)].max
      walk_step = (dv - DANGER_LIMIT_TABLE[stepidx % 65536] - 1) / (RUNNING_DANGER_VALUE - WALKING_DANGER_VALUE) + 1
      if walk_step <= walkable_step
        walk_cnt += walk_step
        next if walk_cnt > WALKING_COUNT_LIMIT
        dv -= walk_step * (RUNNING_DANGER_VALUE - WALKING_DANGER_VALUE)
        dist -= walk_step * (RUNNING_DISTANCE - WALKING_DISTANCE)
        walk_his.fill(1, -walk_step..-1)
        redo
      end
    }
    q = new_q
    # q.sort_by!{|_dist, _walk_cnt, _stepidx, _enc_his, _walk_his| [-_dist, _walk_cnt] }
    enc_cnt += 1
  end
  if ok
    res = q.select{|dist, walk_cnt, stepidx, enc_his, walk_his|
      dist - 1 >= TARGET_DISTANCE
    }.map{|dist, walk_cnt, stepidx, enc_his, walk_his|
      [dist - 1, walk_cnt, stepidx - start_stepidx, enc_his, walk_his]
    }.sort_by{|dist, walk_cnt, stepids_size, enc_his, walk_his|
      [-dist, walk_cnt]
    }
    [enc_cnt - 1, res]
  else
    []
  end
end

keys = %i[start_idx encounter_count distance walking_count stepids_size encounter_history walking_history]
(256 ** 2).times{|start_stepidx|
  enc_cnt, data = min_encounter_search(start_stepidx)
  if !enc_cnt.nil?
    # output only first data
    h = keys.zip([start_stepidx, enc_cnt, *data.first]).to_h
    p h
  end
}
