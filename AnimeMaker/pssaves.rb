require "./animemaker"

require "crc/acrc"

module PlayStation
  class DQ7Save
    include Save

    def fix_128byte(first)
      b = @bin[first, 0x7c]
      checksum = CRC.crc32_bzip2(b)
      @bin.w(first + 0x7c, 4, checksum)
    end
    
    def fix
      # 最初の128byteはxor和0
      a = @bin[0x0000..0x007e]
      checksum_0x0000 = a.bytes.inject :^
      @bin.w(0x007f, 1, checksum_0x0000)

      if true
        # 124+4byteごとに、全て0x00でないならチェックサムを追加
        0x0180.step(0x1fff, 0x80){|i|
          s = @bin[i, 0x7c]
          if s.count("\0") != s.size
            self.fix_128byte(i)
          end
        }
      else
        # 124+4byteごと全部チェックサムを追加
        0x0180.step(0x1fff, 0x80){|i|
          self.fix_128byte(i)
        }
      end
      self
    end

    def modify
      @bin.w(0x0180, 1, 0x00) # or 01
      @bin.w(0x0181, 6, 0x00)
      @bin.w(0x0190, 4, "d0 07 08 00")
      @bin.w(0x01ae, 2, 0x0724) # MapID: 1828

      super
    end

    # 超美麗ムービー(DISC 1)
    def modify_dance1
      @bin.w(0x0180, 1, 0x04)
      @bin.w(0x0181, 6, 0x00)
      @bin.w(0x0190, 4, "d0 07 08 00")
      @bin.w(0x01ae, 2, 0x062e) # MapID: 1582

      # @bin.w(0x0180, 124, "7F 01 00 FE 00 00 00 00 30 40 9E 46 01 01 00 00 D0 07 08 00 0B 00 00 00 03 00 31 00 00 00 00 00 00 00 00 00 A8 05 00 00 00 00 00 00 7B 00 2e 06 00 00 00 F8 00 00 22 00 57 00 00 00 64 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 C0 01 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ")
      # @bin.w(0x0280, 124, "E3 78 BC 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 04 E0 20 CF 21 A5 A3 2D 20 58 40 2B 01 00 00 00 00 00 00 00 00 18 C1 8A 49 BF CA F7 C7 f4 06 00 00 00 00 00 00 A8 5E E6 F4 F7 FF A4 00 27 FB E0 3E 22 57 B9 3E 4F 7C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ")

      # フラグ 全て0x86でok
      @bin.w(0x02b4, 3, "86 86 86")
      # @bin.w(0x02b4, 1, 0x06)
      # @bin.w(0x02b5, 1, 0x80)
      # @bin.w(0x02b6, 1, 0x04)

      self.fix
    end

    # 超美麗ムービー(DISC 2) ※使うのはDSIC 1でok
    def modify_dance2
      # @bin.w(0x180, 124, "
      #   04 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      #   d0 07 08 00 00 00 00 00 00 00 00 00 00 00 00 00
      #   00 00 00 00 00 00 00 00 00 00 00 00 00 00 33 06
      #   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      #   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      #   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      #   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      #   00 00 00 00 00 00 00 00 00 00 00 00
      #   ")
      # @bin.w(0x200, 124, "
      #   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01
      #   f7 ff ff f9 00 89 c6 89 01 c8 67 70 17 00 00 00
      #   00 40 9e 07 dd 09 34 ad a7 41 40 2a 2b 92 d7 8c
      #   2b 9d 0d f9 ff ff ff ff ff ff ff ff ff ff ff ff
      #   3f 00 00 00 60 f6 f3 0f d3 ff af a0 fc f2 2b 00
      #   00 00 00 00 00 00 00 10 00 00 78 79 32 e5 01 80
      #   80 00 00 02 a0 1c 01 51 13 01 06 07 00 00 1c 01
      #   00 20 0b 00 01 10 c0 3b 30 e3 e9 47
      #   ")
      # @bin.w(0x280, 124, "
      #   23 7b fc 47 80 ab 62 7e 00 12 e3 4e 00 08 14 fc
      #   cb 30 28 60 c1 3d 02 38 04 00 2d cf 21 a5 a3 2d
      #   20 58 40 2b 83 00 00 00 20 06 01 00 00 20 a2 88
      #   4d bf fa ff cd 74 37 fe d3 a1 7d 24 00 00 5e e6
      #   f5 f7 ff c4 00 2f 3b e1 be 22 97 b9 3e 6f 7c e0
      #   60 81 41 f0 df 20 00 c0 61 84 07 80 00 00 00 00
      #   00 00 10 87 be 7a 8f 85 ba 0a 45 95 c7 56 08 42
      #   25 8e 23 00 02 40 f1 cb 30 fc 01 8a
      #   ")
      @bin.w(0x0180, 1, 0x04)
      @bin.w(0x0181, 6, 0x00)
      @bin.w(0x0190, 4, "d0 07 08 00")
      @bin.w(0x01ae, 2, 0x0633) # MapID: 1587

      # フラグ
      @bin.w(0x02ba, 1, 0x60)
      # 0x01と0x02のビットフラグを潰す
      b = @bin[0x02bb].ord
      @bin.w(0x02bb, 1, b & ~(0x01 | 0x02))
      
      self.fix
    end

    # エンディング 船の遠景から
    def modify_ending_letter_far_view
      @bin.w(0x0180, 1, 0x00) # or 01
      @bin.w(0x0181, 6, 0x00)
      @bin.w(0x0190, 4, "d0 07 08 00")
      @bin.w(0x01ae, 2, 0x0721) # MapID: 1825

      self.fix
    end

    # エンディング 船の近景から
    def modify_ending_letter_near_view
      @bin.w(0x0180, 1, 0x00) # or 01
      @bin.w(0x0181, 6, 0x00)
      @bin.w(0x0190, 4, "d0 07 08 00")
      @bin.w(0x01ae, 2, 0x0722) # MapID: 1826

      self.fix
    end

    # エンディング ペラッペラの魚から
    def modify_ending_letter_fish
      @bin.w(0x0180, 1, 0x00) # or 01
      @bin.w(0x0181, 6, 0x00)
      @bin.w(0x0190, 4, "d0 07 08 00")
      @bin.w(0x01ae, 2, 0x0715) # MapID: 1813

      self.fix
    end
  end

  class DQ4Save
    include Save

    def fix_128byte(first)
      b = @bin[first, 0x7c]
      checksum = CRC.crc32_bzip2(b)
      @bin.w(first + 0x7c, 4, checksum)
    end
    
    def fix
      # 最初の128byteはxor和0
      a = @bin[0x0000..0x007e]
      checksum_0x0000 = a.bytes.inject :^
      @bin.w(0x007f, 1, checksum_0x0000)

      if true
        # 124+4byteごとに、全て0x00でないならチェックサムを追加
        0x0180.step(0x1fff, 0x80){|i|
          s = @bin[i, 0x7c]
          if s.count("\0") != s.size
            self.fix_128byte(i)
          end
        }
      else
        # 124+4byteごと全部チェックサムを追加
        0x0180.step(0x1fff, 0x80){|i|
          self.fix_128byte(i)
        }
      end
      self
    end

    def modify
      @bin.w(0x0000, 2, "53 43")
      # @bin.w(0x0002, 2, "43 53")

      @bin.w(0x0180, 1, 0x07) # or 06
      @bin.w(0x0181, 4, 0x00)
      @bin.w(0x0190, 4, "d0 07 08 00")
      @bin.w(0x01ae, 2, 0x0089) # MapID: 137
      # x & 0x10 != 0 && x & 0x40 != 0 && x & 0x20 == 0 ;; 64種
      @bin.w(0x0200, 1, 0x50)
      
      # x & 0x80 != 0 && x & 0x40 == 0 ;; 64種
      @bin.w(0x02ac, 1, 0x80)

      super
    end
  end

  class FF7Save
    include Save

    def fix
      b = @bin[0x0204..0x12f3]
      cs = CRC.crc16_genibus(b)
      @bin.w(0x0200, 4, cs)
    end
  
    def modify
      # @bin.w(0x06f8, 3, 0x020202)
      @bin.w(0x06f8, 3, 0x010101)
      @bin.w(0x0d94, 2, 0x0000)
      @bin.w(0x0d96, 2, 0x02fb)
      @bin.w(0x0da4, 2, 0x07cf)
      @bin.w(0x10a4, 1, 0x03)
  
      super
    end
  end

  class FF8Save
    include Save

    @@checksum_table = []
    @@checksum_poly = 0x1021
    def self.init_checksum_table
      @@checksum_table = (0...256).map{|i|
        8.times.inject(i << 8){|c, _|
          ((c << 1) & 0xffff) ^ (c & 0x8000 != 0 ? @@checksum_poly : 0)
        }
      }
      # テーブル最後の要素が0になっている
      @@checksum_table[-1] = 0
    end

    def checksum(bin)
      c = bin.bytes.inject(0xffff){|c, b|
        ((c << 8) & 0xffff) ^ @@checksum_table[((c >> 8) ^ b) & 0xff]
      }
      ~c & 0xffff
    end
  
    def fix
      b = @bin[0x01d0..0x151f]
      cs = self.checksum(b)
      @bin.w(0x0180, 2, cs)
      @bin.w(0x1520, 2, cs)
    end

    def modify
      @bin.w(0x0182, 2, "ff 08")
      @bin.w(0x0ec2, 2, 0x004c)
      @bin.w(0x0fac, 1, 0x04)
      
      super
    end

    init_checksum_table
  end

  class FF9Save
    include Save
    
    def fix
      b = @bin[0x0000..0x13fd]
      cs = CRC.crc16_mcrf4xx(b)
      @bin.w(0x13fe, 2, cs)
    end

    def modify
      @bin.w(0x0100, 4, 0x00030005)
      @bin.w(0x0110, 1, 0xff) # 文字列終端は0x110..0x176 # NO$PSXだと0x17bまで
      @bin.w(0x0104, 1, 0x08) # DISC 4
      # @bin.w(0x0104, 1, 0x00) # DISCチェックカット
      @bin.w(0x0180, 1, 0x04)
      @bin.w(0x01a0, 2, 0x0bc3)

      # test
      @bin.w(0x0180, 2, 0x0304)
      # @bin.w(0x01a4, 2, 0x03aa)

      super
    end
  end
end
