# 必要なもの:
# - crc - CRC calcurator for ruby (https://github.com/dearblue/ruby-crc)
#   - インストールは gem install crc でよい
# - 同じフォルダに
#   - https://github.com/pingval/Speedrun/blob/master/AnimeMaker/pssaves.rb
#   - https://github.com/pingval/Speedrun/blob/master/AnimeMaker/animemaker.rb
#   - crchackのバイナリ(https://github.com/resilar/crchack)
#     - 自分の改造版(https://github.com/pingval/crchack)もあるがこれは要らない

require "open3"
require "tempfile"
require "./pssaves"
include PlayStation

$>.sync = true

# crchackの場所
CRCHACK = "./crchack"
# crchackに渡すコマンドラインオプション(CRCアルゴリズム)
ALGO_OPT = "-w32 -p04c11db7 -iffffffff -xffffffff"
# 指定するCRC値
TARGET_CRC = 0

# 再開地点
# TheEnd: 0x724
# 船の遠景から: 0x721
# 船の近景から: 0x722
# ペラッペラ: 0x715
# 超美麗ムービー1: 0x062e
# 超美麗ムービー2: 0x0633
MapID = 0x0722
# 元のバイナリ
BIN = "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0 07 08 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 #{MapID.bin(2).b2h}
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00".h2b
# 書き換えを禁止するアドレス
NG_ADDRs = [*0x00..0x06, *0x10..0x13, *0x2e..0x2f]
# 書き換えを許可するアドレス
OK_ADDRs = [*0x00..0x37] - NG_ADDRs
# 組み合わせの要素数
COMB_N = 4
# 発見済みのバイナリ
$found = {}

count = 0
total = OK_ADDRs.combination(COMB_N).size

Tempfile.create{|tf|
  tf.binmode.write(BIN)
  tf.close
  OK_ADDRs.combination(COMB_N){|comb|
    count += 1
    # crchackに渡すコマンドラインオプション(書き換えアドレス)
    mod_opt = comb.map{|i| "-b %d:+1" % i } * " "
    cmd = "#{CRCHACK} #{ALGO_OPT} #{mod_opt} #{tf.path} #{TARGET_CRC}"
    o, e, s = Open3.capture3(cmd)
    if !o.empty?
      ob = o.b
      cnt, uniq_cnt = ob.counts
      # 使う色が7未満なら出力
      if uniq_cnt < 7
        # 既出なら飛ばす
        next if $found[o]
        $found[o] = 1
        # 塗るマスの数
        puts "Count:"
        puts "%4d"%cnt
        # 使う色の数
        puts "Unique Count:"
        puts "%4d"%uniq_cnt
        # バイナリ
        puts "Hex:"
        puts o.b2h
        # アニメティカでの塗り方
        puts AM.new("\0" * 0x180 + ob, pos:2).to_s
        # 境界線と進捗
        puts "----" + " #{count}/#{total}"
      end
    end
  }
}
