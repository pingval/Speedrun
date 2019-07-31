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
      a = @bin[0x0000..0x007e]
      checksum_0x0000 = a.bytes.inject :^
      @bin.w(0x007f, 1, checksum_0x0000)

      self.fix_128byte(0x180)
    end

    def modify
      @bin.w(0x0180, 1, 0x00) # or 01
      @bin.w(0x0181, 6, 0x00)
      @bin.w(0x0190, 4, "d0 07 08 00")
      @bin.w(0x01ae, 2, 0x0724) # MapID: 1828

      super
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
      a = @bin[0x0000..0x007e]
      checksum_0x0000 = a.bytes.inject :^
      @bin.w(0x007f, 1, checksum_0x0000)

      [0x0180, 0x0200, 0x0280].each{|addr|
        self.fix_128byte(addr)
      }
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

      super
    end
  end
end
