MEMCARD_N = 2
AM_X_SKIP_SIZE = 30
AM_Y_SKIP_SIZE = 10

class String
  # "00 01" => "\x00\x01"
  def h2b
    [self.tr("^0-9a-fA-F","")].pack("H*")
  end

  # "\x00\x01" => "00 01"
  def b2h
    hex = self.unpack("H*")[0]
    hex.scan(/.{,32}/).map{|s|
      s.scan(/../) * " "
    } * "\n"
  end

  # ちょっと速い
  # def b2h
  #   hex = self.unpack("H*")[0]
  #   s = hex.scan(/../)*" "
  #   s.gsub(/(.{47}) /, "\\1\n")
  # end
  
  def w(idx, size, bin_or_n)
    bin = bin_or_n.class == String ? bin_or_n.h2b[0, size] : bin_or_n.bin(size)
    self[idx, size] = bin
  end

  def counts
    not_blank = self.chars.select{|c| c != "\x00" }
    [not_blank.size, not_blank.uniq.size]
  end
end

class Integer
  # 指定したサイズのバイナリに変換(リトルエンディアン)
  def bin(size)
    h = self
    res = size.times.map{
      (h & 0xff).chr.tap{ h >>= 8 }
    } * ""
    warn "warning: rest of h: 0x%x"%h if h != 0
    res
  end
end

module PlayStation
  # アニメティカの色塗り
  class AnimeMaker < Array
    @@Gap = 0x2300

    # 何ブロック目か
    attr_reader :pos
    # 消費するブロック数
    attr_reader :block
    # 背景色(初期値は00)
    attr_reader :blank

    def fix
      return self if self.empty?
      self.sort!

      minmax = self.minmax_by{|x, y, b| [y, x] }
      l, r = minmax.map{|x, y, b|
        AM.xy2addr(x, y) / 0x2000
      }
      @pos = l
      @block = r - l + 1
      self
    end

    # クラスメソッド: アニメティカ上の座標からメモリーカードのバイナリのアドレスへ変換する
    def self.xy2addr(x, y)
      x + 288 * y + @@Gap
    end
    
    # クラスメソッド: メモリーカードのバイナリのアドレスからアニメティカ上の座標へ変換する
    def self.addr2xy(addr)
      y, x = (addr - @@Gap).divmod(288)
      [x, y]
    end

    # 文字列をパースしてアニメティカのデータを作る
    def self.parse(s, *args)
      res = AM.new(*args)
      s.scan(/^ *([0-9a-fA-F]{2}): *\( *(\d+)(?:..(\d+))?, *(\d+)(?:..(\d+))?\)/){|color, x_first, x_last, y_first, y_last|
        x_last = x_first if x_last.nil?
        y_last = y_first if y_last.nil?
        (x_first.to_i..x_last.to_i).each{|x|
          (y_first.to_i..y_last.to_i).each{|y|
            res << [x, y, color.hex]
          }
        }
      }
      res.fix
    end

    # 何ブロック目かを変更したオブジェクトを返す
    def +(n)
      # p self
      new = self.dup
      new.map!{|x, y, b|
        addr = AM.xy2addr(x, y)
        new_x, new_y = AM.addr2xy(addr + 0x2000 * n)
        [new_x, new_y, b]
      }
      new.pos += n
      new
    end

    def -(n)
      self + -n
    end

    def initialize(bin = "", pos:MEMCARD_N, block:1, blank: 0x00.chr)
      @pos = pos
      @block = block
      @blank = blank.chr

      case bin
      when String
        bin.size.times{|i|
          c = bin[i]
          next if c == @blank
          y, x = (0x2000 * @pos + i - @@Gap).divmod(288)
          self << [x, y, c.ord]
        }
      else
        super
      end
    end

    # セーブデータのバイナリに変換する
    def bin
      fix
      res = @blank * (0x2000 * @block)
      self.each{|x, y, b|
        idx = AM.xy2addr(x, y) - 0x2000 * @pos
        res[idx] = b.chr
      }
      res
    end

    # 文字列へ変換する。引数が真だとアドレス順になる
    def to_s(binary_order = false)
      fix

      res = []
      rest, x_block = self.sort_by{|x, y, b| [y, x] }.chunk_while{|(xx, yy, bb), (x, y, b)|
        x == xx + 1 && y == yy && b == bb
      }.partition{|a| a.size == 1 }
      all = rest.flatten(1).sort_by{|x, y, b| [x, y] }.chunk_while{|(xx, yy, bb), (x, y, b)|
        x == xx && y == yy + 1 && b == bb
      } + x_block
      all.sort_by{|((x, y, b))|
        binary_order ? [y, x] : [x, y]
      }.each{|a|
        lx, ly, lb = a.first
        rx, ry, rb = a.last
        xs = lx == rx ? "%3d"%lx : "%3d..%d"%[lx, rx]
        ys = ly == ry ? "%3d"%ly : "%3d..%d"%[ly, ry]
        res << "  %02X: (%s,%s)" % [lb, xs, ys]
      }
      
      range = @block == 1 ? "#{@pos}" : "#{@pos}..#{@pos + @block - 1}"
    
      "AnimeMaker(used block: ##{range}):\n#{res * "\n"}\n"
    end

    # アニメティカの入力の可視化
    def inspect
      from_x = 287
      to_x = 0
      from_y = 207
      to_y = 0
      # 最低限の範囲を調べる
      self.each{|x, y, b|
        from_x = x if x < from_x
        to_x = x if x > to_x
        from_y = y if y < from_y
        to_y = y if y > to_y
      }
      # from_x = 0
      # to_x = 287
      # from_y = 0
      # to_y = 207

      # 範囲にチェックを入れる
      rect = (from_y..to_y).map{ [self.blank.ord] * (to_x - from_x + 1) }
      used_x = [false] * (to_x - from_x + 1)
      used_y = [false] * (to_y - from_y + 1)
      self.each{|x, y, b|
        used_x[x - from_x] = true
        used_y[y - from_y] = true
        rect[y - from_y][x - from_x] = b
      }
      res = ""
      # ルーラー
      ruler = "y\\x|" + used_x.map.with_index(from_x){|ok, i| ok ? "%3d"%i : "   "} * "" + "\n"
      res << ruler
      res << ?- * 3 + ?+ + "---" * used_x.size + "\n"
      # 座標
      rect.each.with_index(from_y){|line, i|
        l = used_y[i - from_y] ? "%3d"%i : "   "
        r = line.map{|b| b != self.blank.ord ? " %02X"%b :"   " } * ""
        res << l + ?| + r + "\n"
      }
      # yの省略
      res.gsub!(/( +\| +\n){#{AM_Y_SKIP_SIZE},}/){
        ?~ * ($1.size - 1) + "\n"
      }
      # xの省略
      x_skip_range = []
      ruler.scan(/(   ){#{AM_X_SKIP_SIZE},}/){
        x_skip_range << [$~.begin(0), $~.end(0)]
      }
      x_skip_range.reverse!
      res.gsub!(/.+$/){
        s = $&
        x_skip_range.each{|l, r|
          s[l...r] = " ~ "
        }
        s
      }
      res
    end
  end
  AM = AnimeMaker

  # セーブデータのインターフェイス
  module Save
    # 消費するブロック数
    Block = 1
    attr_reader :block
    # 背景色(初期値は00)
    attr_reader :blank
    # バイナリ
    attr_accessor :bin
    
    # チェックサム等を修正する
    def fix

    end

    # データを改竄する
    def modify
      self.fix
    end

    # 0からデータを作る
    def renew
      @bin = @blank * (0x2000 * Block)
      self.modify
    end

    def bin
      self.fix
      @bin
    end

    # アニメティカの色塗りデータに変換
    def am(pos = MEMCARD_N)
      AM.new(@bin, pos: pos, block: Block, blank: @blank)
    end

    def initialize(bin = nil, blank: 0x00.chr)
      @block = Block
      @blank = blank
      @bin = bin || blank * (0x2000 * Block)
    end

    def color_count
      not_blank = @save.chars.select{|c| c != @blank }
      not_blank.size
    end

    def unique_count
      not_blank = @save.chars.select{|c| c != @blank }
      not_blank.uniq.size
    end
  end

  # メモリーカード
  class MemoryCard
    # メモリーカード内のセーブデータ
    attr_reader :saves
    # 使用中のブロック数
    attr_reader :used_block
    attr_reader :filename
  
    # 全てのセーブデータを0から作る
    def renew
      @saves.each{|save| save.renew }
    end

    # 全てのセーブデータを改竄する
    def modify
      @saves.each{|save| save.modify }
    end

    # 全てのセーブデータを修復する
    def fix
      @saves.each{|save| save.fix }
    end

    # クラスを引数にとってセーブデータを追加し、それを返す
    def gets(klass)
      if @used_block + klass::Block > 15
        warn "error: more than 15 blocks in a Memory Card."
        return
      end
      save = klass.new(@bin[0x2000 * (1 + @used_block), 0x2000 * klass::Block])
      @used_block += klass::Block
      @saves << save
      # p [@used_block, 0x2000 * (1 + @used_block), 0x2000 * klass::Block]
      save
    end

    # アニメティカの色塗りデータに変換する
    def am
      self.apply
      # 管理ブロックとアニメティカ(pos:1, block:1)は除く
      AM.new(@bin[0x2000 * MEMCARD_N, 0x2000 * (@used_block - 1)], pos: MEMCARD_N, block: @used_block - 1)
    end

    # ファイルからバイナリを読み込む
    def load(filename = @filename)
      # @filename = filename # ?
      @bin = IO.binread(filename)
    end

    def initialize(filename = nil)
      @saves = []
      @used_block = MEMCARD_N - 1
      @filename = filename

      if filename.nil?
        @bin = 0x00.chr * (0x2000 * 16)
      else
        self.load(@filename)
      end
    end

    # 各セーブデータのバイナリ変更をメモリーカードにも適用する
    def apply
      self.fix
      # 最初は2ブロック目
      x = 0x2000 * MEMCARD_N
      @saves.each{|save|
        @bin[x, save.bin.size] = save.bin
        x += save.bin.size
      }
    end

    # 保存する
    def save
      self.apply
      IO.binwrite(@filename, @bin)
    end

  end
  MC = MemoryCard
end
