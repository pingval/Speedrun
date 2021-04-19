# -*- encoding: utf-8 -*-
# 2021/04/19
# ・game_fpsオプションを追加。Windows7なら61に変更すればうまく動く？
# 2021/03/08
# ・レアカードタイマーが動作しなくなっていた(str2patternメソッドがエラーを吐く)のを修正
# 2021/01/24
# ・FC01版追加ついでにいろいろ変更
# 2017/01/20
# ・カードプレイヤーの定義に走る少年(コモーグリ所持)を追加
# 2016/10/27
# ・"malboro"のtypoのためモルボルパターンを選択できない致命的なバグを修正
# ・英語メッセージをちょこちょこ修正
# 2016/10/25
# ・English is supported (with "language: :en")
# ・エラーメッセージなどちょこちょこ修正
# 2016/10/14
# ・カード乱数消費回数の指定による1戦目からの目押しに対応
# ・それ専用のリカバリにも対応
# ・特に意味はないがカード定義に属性をちゃんと設定
# 2016/07/10
# ・公開

# require "tapp"
require "readline"
require "io/console/size"

$option = {
  # 言語 日本語:ja, English:en
  language: :en,
  
  # 探索の基準とするindex ドール終了:420~520?, ディアボロス直後:500~600?
  base: 550,
  
  # baseを中央として、これだけの幅を探索
  width: 400,
  
  # リカバリ探索時にボタン押下タイミングを中央として、
  # これだけの幅(フレーム数)を探索
  recovery_width: 360,
  
  # 乱数消費回数指定からのリカバリ探索時に、これだけの幅を探索
  counting_width: 100,
  
  # 乱数消費回数指定からのリカバリ探索時に、ボタン押下タイミングを中央として
  # これだけの幅(フレーム数)を探索
  counting_frame_width: 40,
  
  # 先キスカ固定法に用いるパターン。モルボルが出た時以外は実用上は大差ないが
  # 先キスカ固定法本家:luzbelheim (https://www.youtube.com/watch?v=Vi5b9pFz7Fg)
  # 20連コン対応版:pingval (https://www.youtube.com/watch?v=NZepglJrzdI)
  early_quistis: :pingval, # :luzbelheim,
  
  # ゼルママ戦初回の「勝負する」を選ぶ秒間連射速度
  # 初回のマッチングは乱数の系列を「60/これ」だけ探索する
  # 15とか12を設定しておけば連射速度の変更を忘れた日も安心ではある
  # 極最速:30, アナ振II最速:20
  autofire_speed: 12,
  
  # フィールドの「はい」からカード画面の「勝負する」までの最短フレーム数
  # リカバリ探索で平均diffがずれているようなら変更すべき
  # 平均diffが-5なら285+5=290に変更するとかいった風に
  # ps2fast_ja:285(4.75s), ps2_ja:490(8.17s), no$psx:280(4.67s)
  delay_frame: 285,
  
  # カードの強さの入力順。u:↑, r:→, d:↓, l:←
  # "ulrd"だと↑←→↓。
  ranks_order: "ulrd",
  
  # 強く強調するカード
  # キスティス:103, ゼル:105
  strong_highlight_cards: [103, 105], # [105],
  
  # 強調するカード
  # メズマライズ:13、グランデアーロ:21、インビンシブル:48、トンベリキング:53
  highlight_cards: [21, 48, 53],
  
  # 検索順 反転:reverse, 降順:ascending, 昇順:descending, 通常:それ以外
  order: :reverse,
  
  # レアカードタイマーのfps
  console_fps: 60,
  
  # 基本60、Windows7なら61
  game_fps: 60,
  
  # ※これより下は変更不要※
  
  # 対象プレイヤー
  player: :zellmama,
  
  # 曖昧探索を行う順。r:強さ入力, o:手札の並び
  fuzzy: %w[. r o ro],
  
  # 最速で「勝負する」を選択した場合の乱数の状態の加算回数
  forced_incr: 10,
  
  # 「勝負する」を選択してから乱数の状態の加算が停止するまでのフレーム数
  # 実際は3..4?
  accept_delay_frame: 3,

  # プロンプトに表示する文字列
  prompt: "> ",
  
  debug: false,
  fallback_language: :en,
}

# 元データの強さ順
Default_Ranks_Order = "urdl"

# 先キスカ固定法のパターンごとの乱数の状態
Early_Quistis_State_Table = {
  luzbelheim: {
    unused:   0x0000_0001,      # 系列1[0]
    elastoid: 0x1340_eb2b,      # 系列11[992]
    malboro:  0x5f22_3d12,      # 系列12[1354]
    wedge:    0x1f13_2481,      # 一応動くように
  },
  pingval: {
    unused:   0x0000_0001,      # 系列1[0]
    elastoid: 0x1de5_b942,      # 系列11[943]
    malboro:  0x963c_b5e4,      # 系列12[1544]
    wedge:    0x1f13_2481,      # 系列13[1580]
  },
}

# カードID
Quistis_ID = 103                # キスティス
Zell_ID = 105                   # ゼル
Angelo_ID = 77                  # アンジェロ
Pupu_ID = 47                    # コヨコヨ
Minimog_ID = 80                 # コモーグリ

Deck_MAX = 5

module FF8
  # カード乱数
  class Card_RNG < Enumerator::Lazy
    # include Enumerable

    Initial_State = 0x0000_0001
    attr_reader :state, :seed
    attr_accessor :true_rand, :enum_method

    def initialize(seed=Initial_State, enum_method: :get, true_rand: false)
      init(seed)
      @enum_method = enum_method
      @true_rand = true_rand
    end

    def init(seed=nil)
      @seed = (seed.nil? ? rand(0..0xffff_ffff) : seed)
      @state = @seed
    end

    def shuffle
      init
    end

    def next_state
      return rand(0..0xffff_ffff) if @true_rand
#       @state.tap {
#         @state = (@state * 0x10dcd + 1) & 0xffff_ffff
#       }
      @state = (@state * 0x10dcd + 1) & 0xffff_ffff
    end

    # 乱数生成を行う rand(0..32767)
    def nxt
      next_state >> 17
    end
    alias get nxt

    def each
      return to_enum if !block_given?
      
      Enumerator.new {|y|
        loop { y << self.send(@enum_method) }
      }.each {|rnd|
        yield rnd
      }
    end

    def peek
      _state = @state
      self.send(@enum_method).tap { @state = _state }
    end

    def size
      Float::INFINITY
    end

    def rewind
      # @state = Initial_State
      @state = @seed
    end
  end
  
  # カードの定義
  Card_Table = [
    {
      id: 0, urdl: [1, 4, 1, 5], urdl_s: "1415", level: 1, row: 1,
      name: "ハウリザード", name_e: "Geezard", element: :none, rarep: false,
    },
    {
      id: 1, urdl: [5, 1, 1, 3], urdl_s: "5113", level: 1, row: 2,
      name: "フンゴオンゴ", name_e: "Funguar", element: :none, rarep: false,
    },
    {
      id: 2, urdl: [1, 3, 3, 5], urdl_s: "1335", level: 1, row: 3,
      name: "バイトバグ", name_e: "Bite Bug", element: :none, rarep: false,
    },
    {
      id: 3, urdl: [6, 1, 1, 2], urdl_s: "6112", level: 1, row: 4,
      name: "レッドマウス", name_e: "Red Bat", element: :none, rarep: false,
    },
    {
      id: 4, urdl: [2, 3, 1, 5], urdl_s: "2315", level: 1, row: 5,
      name: "プリヌラ", name_e: "Blobra", element: :none, rarep: false,
    },
    {
      id: 5, urdl: [2, 1, 4, 4], urdl_s: "2144", level: 1, row: 6,
      name: "ゲイラ", name_e: "Gayla", element: :thunder, rarep: false,
    },
    {
      id: 6, urdl: [1, 5, 4, 1], urdl_s: "1541", level: 1, row: 7,
      name: "ゲスパー", name_e: "Gesper", element: :none, rarep: false,
    },
    {
      id: 7, urdl: [3, 5, 2, 1], urdl_s: "3521", level: 1, row: 8,
      name: "フォカロルフェイク", name_e: "Fastitocalon-F", element: :earth, rarep: false,
    },
    {
      id: 8, urdl: [2, 1, 6, 1], urdl_s: "2161", level: 1, row: 9,
      name: "ブラットソウル", name_e: "Blood Soul", element: :none, rarep: false,
    },
    {
      id: 9, urdl: [4, 2, 4, 3], urdl_s: "4243", level: 1, row: 10,
      name: "ケダチク", name_e: "Caterchipillar", element: :none, rarep: false,
    },
    {
      id: 10, urdl: [2, 1, 2, 6], urdl_s: "2126", level: 1, row: 11,
      name: "コカトリス", name_e: "Cockatrice", element: :thunder, rarep: false,
    },
    {
      id: 11, urdl: [7, 1, 3, 1], urdl_s: "7131", level: 2, row: 1,
      name: "グラット", name_e: "Grat", element: :none, rarep: false,
    },
    {
      id: 12, urdl: [6, 2, 2, 3], urdl_s: "6223", level: 2, row: 2,
      name: "ブエル", name_e: "Buel", element: :none, rarep: false,
    },
    {
      id: 13, urdl: [5, 3, 3, 4], urdl_s: "5334", level: 2, row: 3,
      name: "メズマライズ", name_e: "Mesmerize", element: :none, rarep: false,
    },
    {
      id: 14, urdl: [6, 1, 4, 3], urdl_s: "6143", level: 2, row: 4,
      name: "グヘイスアイ", name_e: "Glacial Eye", element: :ice, rarep: false,
    },
    {
      id: 15, urdl: [3, 4, 5, 3], urdl_s: "3453", level: 2, row: 5,
      name: "ベルヘルメルヘル", name_e: "Belhelmel", element: :none, rarep: false,
    },
    {
      id: 16, urdl: [5, 3, 2, 5], urdl_s: "5325", level: 2, row: 6,
      name: "スラストエイビス", name_e: "Thrustaevis", element: :wind, rarep: false,
    },
    {
      id: 17, urdl: [5, 1, 3, 5], urdl_s: "5135", level: 2, row: 7,
      name: "ヘッジヴァイパー", name_e: "Anacondaur", element: :poison, rarep: false,
    },
    {
      id: 18, urdl: [5, 2, 5, 2], urdl_s: "5252", level: 2, row: 8,
      name: "クリープス", name_e: "Creeps", element: :thunder, rarep: false,
    },
    {
      id: 19, urdl: [4, 4, 5, 2], urdl_s: "4452", level: 2, row: 9,
      name: "グレンデル", name_e: "Grendel", element: :thunder, rarep: false,
    },
    {
      id: 20, urdl: [3, 2, 1, 7], urdl_s: "3217", level: 2, row: 10,
      name: "ダブルハガー", name_e: "Jelleye", element: :none, rarep: false,
    },
    {
      id: 21, urdl: [5, 2, 5, 3], urdl_s: "5253", level: 2, row: 11,
      name: "グランデアーロ", name_e: "Grand Mantis", element: :none, rarep: false,
    },
    {
      id: 22, urdl: [6, 6, 3, 2], urdl_s: "6632", level: 3, row: 1,
      name: "ライフフォビドン", name_e: "Forbidden", element: :none, rarep: false,
    },
    {
      id: 23, urdl: [6, 3, 1, 6], urdl_s: "6316", level: 3, row: 2,
      name: "エサンスーシ", name_e: "Armadodo", element: :earth, rarep: false,
    },
    {
      id: 24, urdl: [3, 5, 5, 5], urdl_s: "3555", level: 3, row: 3,
      name: "トライフェイス", name_e: "Tri-Face", element: :poison, rarep: false,
    },
    {
      id: 25, urdl: [7, 5, 1, 3], urdl_s: "7513", level: 3, row: 4,
      name: "フォカロル", name_e: "Fastitocalon", element: :water, rarep: false,
    },
    {
      id: 26, urdl: [7, 1, 5, 3], urdl_s: "7153", level: 3, row: 5,
      name: "ゴージュシール", name_e: "Snow Lion", element: :ice, rarep: false,
    },
    {
      id: 27, urdl: [5, 6, 3, 3], urdl_s: "5633", level: 3, row: 6,
      name: "オチュー", name_e: "Ochu", element: :none, rarep: false,
    },
    {
      id: 28, urdl: [5, 6, 2, 4], urdl_s: "5624", level: 3, row: 7,
      name: "SAM08G", name_e: "SAM08G", element: :fire, rarep: false,
    },
    {
      id: 29, urdl: [4, 4, 7, 2], urdl_s: "4472", level: 3, row: 8,
      name: "ワイルドフック", name_e: "Death Claw", element: :fire, rarep: false,
    },
    {
      id: 30, urdl: [6, 2, 6, 3], urdl_s: "6263", level: 3, row: 9,
      name: "サボテンダー", name_e: "Cactuar", element: :none, rarep: false,
    },
    {
      id: 31, urdl: [3, 6, 4, 4], urdl_s: "3644", level: 3, row: 10,
      name: "トンベリ", name_e: "Tonberry", element: :none, rarep: false,
    },
    {
      id: 32, urdl: [7, 2, 3, 5], urdl_s: "7235", level: 3, row: 11,
      name: "アビスウォーム", name_e: "Abyss Worm", element: :earth, rarep: false,
    },
    {
      id: 33, urdl: [2, 3, 6, 7], urdl_s: "2367", level: 4, row: 1,
      name: "グラナトゥム", name_e: "Turtapod", element: :none, rarep: false,
    },
    {
      id: 34, urdl: [6, 5, 4, 5], urdl_s: "6545", level: 4, row: 2,
      name: "バイセージ・ハンズ", name_e: "Vysage", element: :none, rarep: false,
    },
    {
      id: 35, urdl: [4, 6, 2, 7], urdl_s: "4627", level: 4, row: 3,
      name: "アルケオダイノス", name_e: "T-Rexaur", element: :none, rarep: false,
    },
    {
      id: 36, urdl: [2, 7, 6, 3], urdl_s: "2763", level: 4, row: 4,
      name: "ボム", name_e: "Bomb", element: :fire, rarep: false,
    },
    {
      id: 37, urdl: [1, 6, 4, 7], urdl_s: "1647", level: 4, row: 5,
      name: "ブリッツ", name_e: "Blitz", element: :thunder, rarep: false,
    },
    {
      id: 38, urdl: [7, 3, 1, 6], urdl_s: "7316", level: 4, row: 6,
      name: "ウェンディゴ", name_e: "Wendigo", element: :none, rarep: false,
    },
    {
      id: 39, urdl: [7, 4, 4, 4], urdl_s: "7444", level: 4, row: 7,
      name: "クアール", name_e: "Torama", element: :none, rarep: false,
    },
    {
      id: 40, urdl: [3, 7, 3, 6], urdl_s: "3736", level: 4, row: 8,
      name: "ガルキマセラ", name_e: "Imp", element: :none, rarep: false,
    },
    {
      id: 41, urdl: [6, 2, 7, 3], urdl_s: "6273", level: 4, row: 9,
      name: "ドラゴンイゾルデ", name_e: "Blue Dragon", element: :poison, rarep: false,
    },
    {
      id: 42, urdl: [4, 5, 5, 6], urdl_s: "4556", level: 4, row: 10,
      name: "アダマンタイマイ", name_e: "Adamantoise", element: :earth, rarep: false,
    },
    {
      id: 43, urdl: [7, 5, 4, 3], urdl_s: "7543", level: 4, row: 11,
      name: "メルトドラゴン", name_e: "Hexadragon", element: :fire, rarep: false,
    },
    {
      id: 44, urdl: [6, 5, 6, 5], urdl_s: "6565", level: 5, row: 1,
      name: "鉄巨人", name_e: "Iron Giant", element: :none, rarep: false,
    },
    {
      id: 45, urdl: [3, 6, 5, 7], urdl_s: "3657", level: 5, row: 2,
      name: "ベヒーモス", name_e: "Behemoth", element: :none, rarep: false,
    },
    {
      id: 46, urdl: [7, 6, 5, 3], urdl_s: "7653", level: 5, row: 3,
      name: "キマイラブレイン", name_e: "Chimera", element: :water, rarep: false,
    },
    {
      id: 47, urdl: [3, 10, 2, 1], urdl_s: "3a21", level: 5, row: 4,
      name: "コヨコヨ", name_e: "PuPu", element: :none, rarep: false,
    },
    {
      id: 48, urdl: [6, 2, 6, 7], urdl_s: "6267", level: 5, row: 5,
      name: "インビンシブル", name_e: "Elastoid", element: :none, rarep: false,
    },
    {
      id: 49, urdl: [5, 5, 7, 4], urdl_s: "5574", level: 5, row: 6,
      name: "GIM47N", name_e: "GIM47N", element: :none, rarep: false,
    },
    {
      id: 50, urdl: [7, 7, 4, 2], urdl_s: "7742", level: 5, row: 7,
      name: "モルボル", name_e: "Malboro", element: :poison, rarep: false,
    },
    {
      id: 51, urdl: [7, 2, 7, 4], urdl_s: "7274", level: 5, row: 8,
      name: "ルブルムドラゴン", name_e: "Ruby Dragon", element: :fire, rarep: false,
    },
    {
      id: 52, urdl: [5, 3, 7, 6], urdl_s: "5376", level: 5, row: 9,
      name: "エルノーイル", name_e: "Elnoyle", element: :none, rarep: false,
    },
    {
      id: 53, urdl: [4, 6, 7, 4], urdl_s: "4674", level: 5, row: 10,
      name: "トンベリキング", name_e: "Tonberry King", element: :none, rarep: false,
    },
    {
      id: 54, urdl: [6, 6, 2, 7], urdl_s: "6627", level: 5, row: 11,
      name: "ウェッジ・ビッグス", name_e: "Wedge Biggs", element: :none, rarep: false,
    },
    {
      id: 55, urdl: [2, 8, 8, 4], urdl_s: "2884", level: 6, row: 1,
      name: "風神・雷神", name_e: "Fujin Raijin", element: :none, rarep: false,
    },
    {
      id: 56, urdl: [7, 8, 3, 4], urdl_s: "7834", level: 6, row: 2,
      name: "エルヴィオレ", name_e: "Elvoret", element: :wind, rarep: false,
    },
    {
      id: 57, urdl: [4, 8, 7, 3], urdl_s: "4873", level: 6, row: 3,
      name: "X-ATM092", name_e: "X-ATM092", element: :none, rarep: false,
    },
    {
      id: 58, urdl: [7, 2, 8, 5], urdl_s: "7285", level: 6, row: 4,
      name: "グラナルド", name_e: "Granaldo", element: :none, rarep: false,
    },
    {
      id: 59, urdl: [1, 8, 8, 3], urdl_s: "1883", level: 6, row: 5,
      name: "ナムタル・ウトク", name_e: "Gerogero", element: :poison, rarep: false,
    },
    {
      id: 60, urdl: [8, 2, 8, 2], urdl_s: "8282", level: 6, row: 6,
      name: "シュメルケ", name_e: "Iguion", element: :none, rarep: false,
    },
    {
      id: 61, urdl: [6, 8, 4, 5], urdl_s: "6845", level: 6, row: 7,
      name: "アバドン", name_e: "Abadon", element: :none, rarep: false,
    },
    {
      id: 62, urdl: [4, 8, 5, 6], urdl_s: "4856", level: 6, row: 8,
      name: "ドルメン", name_e: "Trauma", element: :none, rarep: false,
    },
    {
      id: 63, urdl: [1, 8, 4, 8], urdl_s: "1848", level: 6, row: 9,
      name: "オイルシッパー", name_e: "Oilboyle", element: :none, rarep: false,
    },
    {
      id: 64, urdl: [6, 5, 8, 4], urdl_s: "6584", level: 6, row: 10,
      name: "シュミ族", name_e: "Shumi Tribe", element: :none, rarep: false,
    },
    {
      id: 65, urdl: [7, 5, 8, 1], urdl_s: "7581", level: 6, row: 11,
      name: "コキュートス", name_e: "Krysta", element: :none, rarep: false,
    },
    {
      id: 66, urdl: [8, 4, 4, 8], urdl_s: "8448", level: 7, row: 1,
      name: "プロパゲーター", name_e: "Propagator", element: :none, rarep: false,
    },
    {
      id: 67, urdl: [8, 8, 4, 4], urdl_s: "8844", level: 7, row: 2,
      name: "ジャボテンダー", name_e: "Jumbo Cactuar", element: :none, rarep: false,
    },
    {
      id: 68, urdl: [8, 5, 2, 8], urdl_s: "8528", level: 7, row: 3,
      name: "トライエッジ", name_e: "Tri-Point", element: :thunder, rarep: false,
    },
    {
      id: 69, urdl: [5, 6, 6, 8], urdl_s: "5668", level: 7, row: 4,
      name: "ガルガンチュア", name_e: "Gargantua", element: :none, rarep: false,
    },
    {
      id: 70, urdl: [8, 6, 7, 3], urdl_s: "8673", level: 7, row: 5,
      name: "機動兵器８型ＢＩＳ", name_e: "Mobile Type 8", element: :none, rarep: false,
    },
    {
      id: 71, urdl: [8, 3, 5, 8], urdl_s: "8358", level: 7, row: 6,
      name: "アンドロ", name_e: "Sphinxara", element: :none, rarep: false,
    },
    {
      id: 72, urdl: [8, 8, 5, 4], urdl_s: "8854", level: 7, row: 7,
      name: "ティアマト", name_e: "Tiamat", element: :none, rarep: false,
    },
    {
      id: 73, urdl: [5, 7, 8, 5], urdl_s: "5785", level: 7, row: 8,
      name: "BGH251F2", name_e: "BGH251F2", element: :none, rarep: false,
    },
    {
      id: 74, urdl: [6, 8, 4, 7], urdl_s: "6847", level: 7, row: 9,
      name: "ウルフラマイター", name_e: "Red Giant", element: :none, rarep: false,
    },
    {
      id: 75, urdl: [1, 8, 7, 7], urdl_s: "1877", level: 7, row: 10,
      name: "カトブレパス", name_e: "Catoblepas", element: :none, rarep: false,
    },
    {
      id: 76, urdl: [7, 7, 8, 2], urdl_s: "7782", level: 7, row: 11,
      name: "アルテマウェポン", name_e: "Ultima Weapon", element: :none, rarep: false,
    },
    {
      id: 77, urdl: [4, 4, 8, 9], urdl_s: "4489", level: 8, row: 1,
      name: "デブチョコボ", name_e: "Chubby Chocobo", element: :none, rarep: true,
    },
    {
      id: 78, urdl: [9, 6, 7, 3], urdl_s: "9673", level: 8, row: 2,
      name: "アンジェロ", name_e: "Angelo", element: :none, rarep: true,
    },
    {
      id: 79, urdl: [3, 7, 9, 6], urdl_s: "3796", level: 8, row: 3,
      name: "ギルガメッシュ", name_e: "Gilgamesh", element: :none, rarep: true,
    },
    {
      id: 80, urdl: [9, 3, 9, 2], urdl_s: "9392", level: 8, row: 4,
      name: "コモーグリ", name_e: "MinMog", element: :none, rarep: true,
    },
    {
      id: 81, urdl: [9, 4, 8, 4], urdl_s: "9484", level: 8, row: 5,
      name: "コチョコボ", name_e: "Chicobo", element: :none, rarep: true,
    },
    {
      id: 82, urdl: [2, 9, 9, 4], urdl_s: "2994", level: 8, row: 6,
      name: "ケツァクウァトル", name_e: "Quezacotl", element: :thunder, rarep: true,
    },
    {
      id: 83, urdl: [6, 7, 4, 9], urdl_s: "6749", level: 8, row: 7,
      name: "シヴァ", name_e: "Shiva", element: :ice, rarep: true,
    },
    {
      id: 84, urdl: [9, 6, 2, 8], urdl_s: "9628", level: 8, row: 8,
      name: "イフリート", name_e: "Ifrit", element: :fire, rarep: true,
    },
    {
      id: 85, urdl: [8, 9, 6, 2], urdl_s: "8962", level: 8, row: 9,
      name: "セイレーン", name_e: "Siren", element: :none, rarep: true,
    },
    {
      id: 86, urdl: [5, 1, 9, 9], urdl_s: "5199", level: 8, row: 10,
      name: "セクレト", name_e: "Sacred", element: :earth, rarep: true,
    },
    {
      id: 87, urdl: [9, 5, 2, 9], urdl_s: "9529", level: 8, row: 11,
      name: "ミノタウロス", name_e: "Minotaur", element: :earth, rarep: true,
    },
    {
      id: 88, urdl: [8, 4, 10, 4], urdl_s: "84a4", level: 9, row: 1,
      name: "カーバンクル", name_e: "Carbuncle", element: :none, rarep: true,
    },
    {
      id: 89, urdl: [5, 10, 8, 3], urdl_s: "5a83", level: 9, row: 2,
      name: "ディアボロス", name_e: "Diablos", element: :none, rarep: true,
    },
    {
      id: 90, urdl: [7, 10, 1, 7], urdl_s: "7a17", level: 9, row: 3,
      name: "リヴァイアサン", name_e: "Leviathan", element: :water, rarep: true,
    },
    {
      id: 91, urdl: [8, 10, 3, 5], urdl_s: "8a35", level: 9, row: 4,
      name: "オーディン", name_e: "Odin", element: :none, rarep: true,
    },
    {
      id: 92, urdl: [10, 1, 7, 7], urdl_s: "a177", level: 9, row: 5,
      name: "パンデモニウム", name_e: "Pandemonia", element: :wind, rarep: true,
    },
    {
      id: 93, urdl: [7, 4, 6, 10], urdl_s: "746a", level: 9, row: 6,
      name: "ケルベロス", name_e: "Cerberus", element: :none, rarep: true,
    },
    {
      id: 94, urdl: [9, 10, 4, 2], urdl_s: "9a42", level: 9, row: 7,
      name: "アレクサンダー", name_e: "Alexander", element: :holy, rarep: true,
    },
    {
      id: 95, urdl: [7, 2, 7, 10], urdl_s: "727a", level: 9, row: 8,
      name: "フェニックス", name_e: "Phoenix", element: :fire, rarep: true,
    },
    {
      id: 96, urdl: [10, 8, 2, 6], urdl_s: "a826", level: 9, row: 9,
      name: "バハムート", name_e: "Bahumut", element: :none, rarep: true,
    },
    {
      id: 97, urdl: [3, 1, 10, 10], urdl_s: "31aa", level: 9, row: 10,
      name: "グラシャラボラス", name_e: "Doomtrain", element: :poison, rarep: true,
    },
    {
      id: 98, urdl: [4, 4, 9, 10], urdl_s: "449a", level: 9, row: 11,
      name: "エデン", name_e: "Eden", element: :none, rarep: true,
    },
    {
      id: 99, urdl: [10, 7, 2, 8], urdl_s: "a728", level: 10, row: 1,
      name: "ウォード", name_e: "Ward", element: :none, rarep: true,
    },
    {
      id: 100, urdl: [6, 7, 6, 10], urdl_s: "676a", level: 10, row: 2,
      name: "キロス", name_e: "Kiros", element: :none, rarep: true,
    },
    {
      id: 101, urdl: [5, 10, 3, 9], urdl_s: "5a39", level: 10, row: 3,
      name: "ラグナ", name_e: "Laguna", element: :none, rarep: true,
    },
    {
      id: 102, urdl: [10, 8, 6, 4], urdl_s: "a864", level: 10, row: 4,
      name: "セルフィ", name_e: "Selphie", element: :none, rarep: true,
    },
    {
      id: 103, urdl: [9, 6, 10, 2], urdl_s: "96a2", level: 10, row: 5,
      name: "キスティス", name_e: "Quistis", element: :none, rarep: true,
    },
    {
      id: 104, urdl: [2, 6, 9, 10], urdl_s: "269a", level: 10, row: 6,
      name: "アーヴァイン", name_e: "Irvine", element: :none, rarep: true,
    },
    {
      id: 105, urdl: [8, 5, 10, 6], urdl_s: "85a6", level: 10, row: 7,
      name: "ゼル", name_e: "Zell", element: :none, rarep: true,
    },
    {
      id: 106, urdl: [4, 10, 2, 10], urdl_s: "4a2a", level: 10, row: 8,
      name: "リノア", name_e: "Rinoa", element: :none, rarep: true,
    },
    {
      id: 107, urdl: [10, 10, 3, 3], urdl_s: "aa33", level: 10, row: 9,
      name: "イデア", name_e: "Edea", element: :none, rarep: true,
    },
    {
      id: 108, urdl: [6, 9, 10, 4], urdl_s: "69a4", level: 10, row: 10,
      name: "サイファー", name_e: "Seifer", element: :none, rarep: true,
    },
    {
      id: 109, urdl: [10, 4, 6, 9], urdl_s: "a469", level: 10, row: 11,
      name: "スコール", name_e: "Squall", element: :none, rarep: true,
    },
  ]
  
  # カードプレイヤーの定義
  Card_Player_Table = {
    fc01: {
      name: "トゥリープFC会員01番",
      name_e: "Trepe Groupie #1",
      rares: [Quistis_ID],
      rare_limit: 30,
      levels: [2, 5],
    },
    fc02: {
      name: "トゥリープFC会員02番",
      name_e: "Trepe Groupie #2",
      rares: [Quistis_ID],
      rare_limit: 20,
      levels: [1, 3, 5],
    },
    fc03: {
      name: "トゥリープFC会員03番",
      name_e: "Trepe Groupie #3",
      rares: [Quistis_ID],
      rare_limit: 10,
      levels: [1, 2, 4, 5],
    },
    zellmama: {
      name: "ゼルママ",
      name_e: "Ma Dincht",
      rares: [Zell_ID],
      rare_limit: 10,
      levels: [1, 2, 4, 5],
    },
    running_boy1: {
      name: "走る少年(DISC 1)",
      name_e: "Running Boy (DISC 1)",
      rares: [80], # コモーグリ
      rare_limit: 20,
      levels: [1, 2, 3],
    },
    watts: {
      name: "ワッツ",
      name_e: "Watts",
      rares: [Angelo_ID],
      rare_limit: 30,
      levels: [1, 4],
    },
  }
end

include FF8

# i18n的な
String_Resources = {
  ja: {
#     fallback_test: "ふぉーるばっくてすと",
    pattern2str_fmt: "先手: %s\n手札: %s",
    no_target: "対象が存在しません。",
    prompt: {
      rare_search: "Enter:レアカードタイマー開始 (h:ヘルプ, q:終了, else:リカバリ探索):",
      after_normal_search: "Enter:レアカードタイマー開始 (h:ヘルプ, q:終了, else:探索パターン変更):",
      second_game_method: "連射ボタンで「勝負する」を選択し、\nカード勝負1戦目の開幕状況パターンを入力してください (h:ヘルプ, q:終了):",
      first_game_method: "Enter:レアカードタイマー開始 (h:ヘルプ, q:終了):",
      rare_timer: "*:レア (Enterで停止・リカバリ探索)",
    },
    str2pattern: {
      UnmatchedInput_fmt: "4枚以上のカードが入力されていません: %s",
      EmptyIDs_fmt: "強さに対応するカードが存在しません: %s",
      read_as_fuzzy: "曖昧入力として再度読み取ります...",
      DuplicatedIDs_fmt: "カードが重複しています: %s",
    },
    fuzzy: {
      fmt: "曖昧探索: %s",
      ranks: "強さ入力",
      order: "手札の並び",
      strict: "厳密"
    },
    initiative: {
      player: "Player",
      cpu: "CPU",
      any: "両方",
    },
    read_argv: {
      unused: "初期値",
      elastoid: "インビンシブル",
      malboro: "モルボル",
      wedge: "ウェッジビッグス",
      pattern_fmt: "%s・%sパターン",
      select_fmt: "%sを選択",
      direct_rng_state_fmt: "乱数の状態の直接指定: 0x%08x",
      advanced_rng_fmt: "=> Card_RNG[%d]: 0x%08x",
    },
    help: {
      first: <<__EOF__,
Usage: #{File.basename(__FILE__, ".*")} early_quistis [count]
early_quistis	先キスカ固定法使用時の2番目のカード
		0:先キスカ不使用, 1:インビンシブル, 2:モルボル, 3:ウェッジ
		その他:16進数で乱数の状態を直接指定しレアカードタイマー開始。
count		ゼルママ戦までのカード乱数消費回数。
		これを指定した場合、1戦目からレアカードタイマーを開始する。

1. ゼルママとのカード勝負画面で「勝負する」を連射ボタンで選択する。
2. カード勝負を行いながら開幕状況パターンを入力し、マッチさせる。
3. ゼルママとの再戦時、フィールドでの「はい」の選択と同時にEnterを押し、
   レアカードタイマーを開始する。
4. 連続した"*"の中央部分が左端の"!"にちょうど重なるところで
   「勝負する」を選択し、同時にEnterを押してタイマーを止める。
5. ゼルママの手札にゼルカードが入っているので奪い取る。
__EOF__
      last: <<__EOF__,
※工程2でマッチしない場合、その原因は以下のようなものが考えられる。
  ・誤った先キスカ固定法パターンをスクリプトの引数に指定している。
  ・ゼルママ戦以前に先キスカ固定以外のカード画面を開いている。
  ・ゼルママ戦の「勝負する」を
    $option[:autofire_speed]以上の連射速度で選択していない。
  ・探索範囲($option[:width])が狭い。
※工程3と4の「はい」と「勝負する」は、連射設定していないボタンでの選択を推奨。
※ゼルカードを奪えなかった場合、工程2のように開幕状況パターンを入力すれば
  タイマーの停止タイミングから再び乱数の状態を特定するリカバリ探索を行える。
  これはゼルママからゼルカードを奪い取るまで何度でもできる。
※countを指定または乱数の状態を直接指定した場合、
  乱数の特定をすっ飛ばして工程3から実行できる。
__EOF__
      continue: "Press Enter to continue...",
      pattern: <<__EOF__,
・方向キーの上下で入力履歴を辿ることができる。
・開幕状況パターンは「相手手札のカード」と「プレイヤーの先後」で表す。
・相手手札のカード
  ・強さを入力する。入力順は上左右下($option[:ranks_order]で変更可能)。
  ・ゼル(上:8, 左:6, 右:5, 下:A)は「8650」または「865a」となる。
  ・強さの入力順を誤っても自動で修正される。
  ・ゼルカードの入力は省略可能。
・プレイヤーの先後
  ・+:先手, -:後手
  ・パターン中どこに書いてもよい。
  ・省略可能。その場合先手/後手両方にマッチする。
・以下のパターンは全て、相手の手札が[ゼル, ゲイラ, ボム, モルボル, ブエル]
  かつプレイヤーが先手の状況を表す:
+8650.2414.2376.7274.6322       # 基本?
+0568.1244.7326.4772.2362       # 入力順を誤っても自動で修正される
+2414.2376.7274.6322            # ゼルカードは省略できる(リカバリ時推奨)
+86502414237672746322           # カードは連続して入力してもよい
+8650``2414^^2376""7274''6322   # カードの境界は何を挟んでもよい
8650.2414.2376.7274.6322+       # 先後はどこに書いてもよい
8650-2414-2376-7274+6322        # 先後は一番後ろにあるものが採用される
8650.2414.2376.7274.6322        # 先後は省いても探索可能
__EOF__
    },
  },
  en: {
    fallback_test: "fallbacktest",
    pattern2str_fmt: "Initiative: %s\nDeck: %s",
    no_target: "There is no target.",
    prompt: {
      rare_search: "Enter:start Rare Card Timer (h:Help, q:Quit, else:Recovery Search):",
      after_normal_search: "Enter:start Rare Card Timer (h:Help, q:Quit, else:change Pattern for Search):",
      second_game_method: "Please hit \"Play\" with turbo button\nand input the opening situation of the 1st game (h:Help, q:Quit):",
      first_game_method: "Enter:start Rare Card Timer (h:Help, q:Quit)",
      rare_timer: "*:Rare (Enter:stop to enter Recovery Search)",
    },
    str2pattern: {
      UnmatchedInput_fmt: "There are not 4 or more cards: %s",
      EmptyIDs_fmt: "There is no card corresponding to ranks: %s",
      read_as_fuzzy: "read again as fuzzy input...",
      DuplicatedIDs_fmt: "Duplicated Cards: %s",
    },
    fuzzy: {
      fmt: "Fuzzy: %s",
      ranks: "Ranks",
      order: "Order",
      strict: "Strict"
    },
    initiative: {
      player: "Player",
      cpu: "CPU",
      any: "Any",
    },
    read_argv: {
      unused: "Initial Value",
      elastoid: "Elastoid",
      malboro: "Malboro",
      wedge: "Wedge&Biggs",
      pattern_fmt: "%s %s pattern",
      select_fmt: "%s is selected",
      direct_rng_state_fmt: "RNG state is selected directly: 0x%08x",
      advanced_rng_fmt: "=> Card_RNG[%d]: 0x%08x",
    },
    help: {
      first: <<__EOF__,
Usage: #{File.basename(__FILE__, ".*")} early_quistis [count]
early_quistis	The 2nd card in CPU\'s deck when you use Early Quistis.
		0: unused, 1: Elastoid, 2: Malboro, 3: Wedge&Biggs,
		etc: select the Card RNG state directly with hex
                     then you can use the rare card timer on the 1st game.
count		How many times the Card RNG is used until Ma Dincht.
		When you put this argument,
                you can use the rare card timer on the 1st game.

1. On the screen on the 1st game with Ma Dincht, hit "Play" with turbo button.
2. While playing the game, input the opening situation pattern and match it.
3. Just before the next game with her, hit "Yes" on the field
   and press Enter at the same time. And start the rare card timer.
4. When the center of the secuence of "*" overlaps "!" at the leftmost,
   hit "Play" and press Enter to stop timer at the same time.
5. She draws Zell card and you can get it.
__EOF__
      last: <<__EOF__,
Note:
- If you didn\'t match at step 2, the reasons are considered as follows:
  - Wrong Early Quistis pattern was put on 1st argument of the script.
  - You had entered the card game screen before Ma Dincht.
  - "Play" was not hit with turbo speed not less than $option[:autofire_speed].
  - The search range ($option[:width]) was narrow.
- At step 3 and 4, 
  it is recommended to hit both of "Yes" and "Play" with non-turbo button.
- If you could\'t gain Zell card,
  input the opening situation of the game just like step 2.
  You can do recovery search to specify RNG state from timing where you stopped
  And you can do that any number of times until you get Zell card.
- When you put the count of RNG on 2nd argument or select RNG state directly,
  You can perform from step 3. The process of to specify RNG state is skipped.
__EOF__
      continue: "Press Enter to continue...",
      pattern: <<__EOF__,
- You can track back your input history with the up and down arrow keys.
- The opening situation is expressed by
  "CPU's deck" and "Which side has initiative".
- CPU\'s deck
  - Input ranks. The order is u-l-r-d. (changeable by $option[:ranks_order])
  - Zell card (up:8, left:6, right:5, down:A) is expressed by "8650" or "865a".
  - Even if you input wrong order, it is automatically modified.
  - Input of Zell card is skippable.
- Which side has initiative
  - +: Player, -: CPU
  - Anywhere in pattern is allowed.
  - Skippable. In that case, the pattern matches both.
- All the following patterns mean the opening situation that
  CPU\'s deck is [Zell, Gayla, Bomb, Malboro, Buel] and player has initiative.
+8650.2414.2376.7274.6322       # basically?
+0568.1244.7326.4772.2362       # automatically modified even if wrong order
+2414.2376.7274.6322            # Zell card is skippable
+86502414237672746322           # sequential input is allowed
+8650``2414^^2376""7274''6322   # any chars between ranks are allowed
8650.2414.2376.7274.6322+       # initiative anywhere is allowed
8650-2414-2376-7274+6322        # the last initiative is adopted
8650.2414.2376.7274.6322        # initiative is skippable
__EOF__
    },
  },
}
T = $option[:language].tap{|lang|
  break (String_Resources[lang] || {}).merge({
    card: Card_Table.map{|c|
      lang == :ja ? c[:name] : c[:name_e]
    }
  })
}
# i18n.t的な
def t(s)
  f = lambda{|string_resource, keys|
    keys.inject(string_resource){|h, k| h.fetch(k, {})}
  }
  keys = s.split(".").map{|k|
    # keyが数字なら配列のindexとして扱う
    k =~ /\A\d+\Z/ ? k.to_i : k.intern
  }
  r = f.(T, keys)
  if r == {}
    # 見つからなければfallback_languageを適用
    r = f.(String_Resources[$option[:fallback_language]], keys)
  end
  r == {} ? s : r
end

# カード勝負の開幕状況を返す
def opening_situation1(rares: [], rare_limit: 10, levels:[1], state: 1, norare: false)
  rng = Card_RNG.new(state)
  deck = []
  
  # レアカード1枚目:rare_limit%, 2枚目以降:rare_limit/2%
  if !norare
    rares.each{|rare_id|
      limit = deck.empty? ? rare_limit : rare_limit / 2
      deck << rare_id if rng.get % 100 < limit
      break if deck.size >= Deck_MAX
    }
  end
  
  # 手札5枚まで
  while deck.size < Deck_MAX
    lv = levels[rng.get % levels.size]
    row_1 = rng.get % 11
    card = (lv - 1) * 11 + row_1
    # コヨコヨ or 重複すればlvからやり直し
    redo if card == Pupu_ID || deck.include?(card)
    deck << card
  end
  # 先後
  initiative = (rng.get & 1) != 0
  
  return {
    deck: deck,                 # 手札
    initiative: initiative,     # (プレイヤーの)先手
    first_state: state,         # 最初の状態
    last_state: rng.state,      # 最後の状態
  }
end

# 乱数の状態とプレイヤーからカード勝負の開幕状況を返す
def opening_situation(state: 1, player: $option[:player], norare: false)
  opening_situation1(
    rares: Card_Player_Table[player][:rares],
    rare_limit: Card_Player_Table[player][:rare_limit],
    levels: Card_Player_Table[player][:levels],
    state: state,
    norare: norare
    )
end

# 開幕状況のテーブルを構築する
def make_opening_table(from, to, state: 1, player: nil, search_type: :first, incr: 0)
#   p "mot", Hash[self.method(__callee__).parameters.map do |arg_type,arg|
#     [ arg, eval(arg.to_s) ]
#   end]
  size = to + 1
  rng_state_arr = \
  case search_type
  when :first
    rng = Card_RNG.new(state)
    Array.new(size){ rng.state.tap{ rng.get } }
  when :counting
    first_state, _, count, _ = read_argv(ARGV, silent: true)
    rng = Card_RNG.new(first_state)
    max_idx = count + $option[:counting_width] # 念のため大きめ
#     p first_state, count, max_idx
    Array.new(max_idx){ rng.state.tap{ rng.get } + incr }
  else
    Array.new(size){|i| (state + i) & 0xffff_ffff }
  end
  offset_arr = \
  case search_type
  when :first
    Array.new(60.quo($option[:autofire_speed]).ceil) {|i|
      $option[:forced_incr] + i
    }
  when :counting
    Array.new($option[:counting_frame_width]) {|i|
      i - $option[:counting_frame_width] / 2
    }
  else
    [0]
  end
  
  (0..to).map{|idx|
    next nil if !idx.between?(from, to)
    
    offset_arr.map{|offset|
      rng_state = (rng_state_arr[idx] + offset) & 0xffff_ffff
      {
        # 初回サーチは同じindexの要素が複数あることになる
        index: idx,
        offset: offset,
        opening: opening_situation(state: rng_state, player: player)
      }
    }
  }.compact.flatten
end

# 強さにマッチするカードIDを複数返す。
# fuzzyなら並び順を考慮しない。
def urdl2ids(urdl, fuzzy_ranks: false)
  test = \
  if fuzzy_ranks
    lambda{|v| v[:urdl].sort == urdl.sort }
  else
    lambda{|v| v[:urdl] == urdl }
  end
  
  Card_Table.select(&test).map{|v| v[:id] }
end

class OpeningPatternError < StandardError; end
class EmptyInput < OpeningPatternError; end
class UnmatchedInput < OpeningPatternError; end
class EmptyIDs < OpeningPatternError; end
class DuplicatedIDs < OpeningPatternError; end

def str2pattern1(s, fuzzy_ranks: false, silent: false)
  rare = Card_Player_Table[$option[:player]][:rares].first
  
  # 最大5枚にマッチする
  ranks_arr = s.scan(/[0-9a]{4}/i).first(5)
  raise UnmatchedInput, t("str2pattern.UnmatchedInput_fmt") % [s] if ranks_arr.size < (rare.nil? ? 5 : 4)
  # 先後は最後に指定されたものを採用
  initiative = s.scan(/[+-]/).inject(nil) {|_, c| c == "+" }
  
  # カスタムされた強さ入力順
  custom_ranks_order = Default_Ranks_Order.chars.map{|c|
    $option[:ranks_order].index(c)
  }
  # 入力された強さからカードの配列を得る
  urdl_arr = ranks_arr.map{|ranks|
    ranks.chars.map{|c|
      c.hex.tap{|n| break 10 if n.zero? }
    }.values_at(*custom_ranks_order)
  }
  ids_arr = urdl_arr.map{|urdl|
    urdl2ids(urdl, fuzzy_ranks: fuzzy_ranks)
  }
  no_arr2s = lambda {|no_arr|
    no_arr.map {|no| "#%d:%s" % [no, ranks_arr[no-1]] }
  }
  # 強さに対応するカードがないがなければ
  # エラーの起きたカードのみ曖昧入力としての読み取りを試みる
  begin
    if ids_arr.any?(&:empty?)
      empty_no_arr = ids_arr.map.with_index(1){|ids, no|
        no if ids.empty?
      }.compact
      raise EmptyIDs, t("str2pattern.EmptyIDs_fmt") % ["#{no_arr2s.(empty_no_arr).join(', ')}"]
    end
  rescue EmptyIDs => err
    retry_count = (retry_count || 0) + 1
    raise err if fuzzy_ranks || retry_count > 1
    
    if !silent
      puts err
      puts t("str2pattern.read_as_fuzzy")
    end
    ids_arr = urdl_arr.map.with_index(1){|urdl, no|
      fuzzyp = empty_no_arr.include?(no)
      urdl2ids(urdl, fuzzy_ranks: fuzzyp)
    }
    retry
  end
  
  # 曖昧検索でなく、かつ重複があればエラー
  # 曖昧検索でも重複したのが単数配列ならエラー
  ids_arr.map{|ids|
    if !fuzzy_ranks
      ids_arr.count(ids) > 1 ? ids : nil
    else
      ids.size == 1 && ids_arr.count(ids) > 1 ? ids : nil
    end
  }.tap{|arr_except_uniq|
    break if arr_except_uniq.compact.empty?
    duplicated_no_arr = arr_except_uniq.map.with_index(1){|v, no|
      v.nil? ? nil : no
    }.compact
    raise DuplicatedIDs, t("str2pattern.DuplicatedIDs_fmt") % ["#{no_arr2s.(duplicated_no_arr).join(", ")}"]
  }
  # 最後、4枚しかなければ先頭にゼルカードを追加
  # 重複チェックとかめんどい
  ids_arr.unshift([rare]) if ids_arr.size == 4
  
  {
    str: s,                     # 元文字列
    deck: ids_arr,              # デッキ
    initiative: initiative,     # (プレイヤーの)先後
  }
end

# 文字列を開幕状況のパターンに変換する
def str2pattern(*args, **keys)
  begin
    str2pattern1(*args, **keys)
  rescue OpeningPatternError => err
    puts err
    nil
  end
end

# パターンをわかりやすい文字列に変換
def pattern2str(pattern)
  deck_s = pattern[:deck].map{|ids|
    names = ids.map{|id|
      s = t("card.#{id}")
      s = "*#{s}*" if $option[:highlight_cards].include?(id)
      s = "**#{s}**" if $option[:strong_highlight_cards].include?(id)
      s
    }.join("|")
    ids.size == 1 ? names : "(#{names})"
  }.join(", ")
  initiative_s = case pattern[:initiative]
  when true then t("initiative.player")
  when false then t("initiative.cpu")
  else t("initiative.any")
  end
  t("pattern2str_fmt") % [initiative_s, deck_s]
end

# 開幕状況のマッチ
def opening_match?(pattern, data, fuzzy_order: false)
  opening = data[:opening]
  
  # 先後
  return if !case pattern[:initiative]
  when true, false
    pattern[:initiative] == opening[:initiative]
  else
    true
  end
  
  # 手札
  pat_deck = fuzzy_order ? pattern[:deck].sort : pattern[:deck]
  deck = fuzzy_order ? opening[:deck].sort : opening[:deck]
  pat_deck.zip(deck).all?{|ids, id|
    ids.include?(id)
  }
end

# 開幕状況を探索するクロージャを返す
# incrはリカバリ探索時のみ使用
def opening_scanner(state: nil, player: nil, search_type: :first, incr: 0)
#   p "os", Hash[self.method(__callee__).parameters.map do |arg_type,arg|
#     [ arg, eval(arg.to_s) ]
#   end]
  case search_type
  when :first
    # 探索開始地点
    start_index = $option[:base]
  when :counting
    _, _, start_index, _ = read_argv(ARGV, silent: true)
  else
    start_index = $option[:recovery_width] / 2
    state = (state + incr - start_index) & 0xffff_ffff
  end

  # 探索順(インデックスの配列)
  order = lambda{|width|
    order = ([start_index] + 1.upto(width / 2).map{|offset|
      [start_index + offset, start_index - offset]
    }).flatten.select{|idx|
      idx >= 0
    }
    order.delete(order.max) if width.even?
    
    case $option[:order]
    when :reverse    then order.reverse!
    when :ascending  then order.sort!
    when :descending then order.sort!.reverse!
    end
  }.( \
  case search_type
  when :first
    $option[:width]
  when :counting
    $option[:counting_width]
  else
    $option[:recovery_width]
  end)
  # 必要なだけテーブルを構築
  table = make_opening_table(order.min, order.max, state: state, player: player, search_type: search_type, incr: incr)
  
  # スキャナを返す
  lambda{|pattern, fuzzy_order: false|
    order.map{|idx|
      data_arr = table.select{|v| v[:index] == idx }
      data_arr.map {|data|
        if opening_match?(pattern, data, fuzzy_order: fuzzy_order)
          {
            diff: idx - start_index, # 探索開始地点との差分
            index: idx,         # インデックス
            data: data,
          }
        end
      }
    }.flatten.compact
  }
end

# 次のカード乱数がレアカードを出すか
def next_rare?(state, rare_limit)
  next_rnd = ((state * 0x10dcd + 1) & 0xffff_ffff) >> 17
  next_rnd % 100 < rare_limit
end

# ローカル変数が多すぎてきもちわるい
def rare_timer1(state: 1, rare_limit: 10, width: 60, fps: 60)
  start = Time.now.to_f
  delay = $option[:delay_frame].quo($option[:game_fps])
  # 状態の加算の開始タイミング
  incr = 0
  incr_start = delay - $option[:forced_incr].quo($option[:game_fps])
  timer_width = 8
  width = [IO.console_size[1] - 1 - timer_width, width].min
  
  header = "timer".ljust(timer_width)
  header << "! "
  header << t("prompt.rare_timer")
  puts  header
  
  f = lambda {
    duration = Time.now.to_f - start
    # 状態の加算回数
    incr = [((duration - incr_start) * $option[:game_fps]).round,
            $option[:forced_incr] + $option[:accept_delay_frame]].max
    # ○連打で安全ならそれとわかるように
    if incr <= $option[:forced_incr] + $option[:accept_delay_frame]
      incr = $option[:forced_incr]
    end
    rare_tbl = Array.new(width) {|i|
      next_rare?(state + incr + i, rare_limit)
    }
    dur_s = "%.2fs%s" % [duration - delay, rare_tbl.first ? "!" : ""]
    
    print dur_s.ljust(timer_width)
    print rare_tbl.map.with_index {|b, i|
      # * > | > -
      if b
        "*"
      elsif i.zero?
        "!"
      else
        "-"
      end
    }.join("")
    print "\r"
  }
  begin
    loop {
      f.()
      sleep(1.quo(fps))
    }
  ensure
    # 必ずstateの加算回数を返す
    return incr
  end
end

# 乱数の状態とプレイヤーからレアカードタイマーを開始する
def rare_timer(state: nil, player: nil)
  Thread.new {
    rare_limit = Card_Player_Table[player][:rare_limit]
    rare_timer1(state: state, rare_limit: rare_limit, fps: $option[:console_fps])
  }.tap{|t|
    t.kill if STDIN.gets
    break t.value
  }
end

# 探索結果を出力する
def output_search_result(r)
  # 開始地点に最も近いインデックス 絶対値が等しいなら若い方
  nearest_index = r.min_by{|v| [v[:diff].abs, v[:diff]] }[:index]
  puts "diff\tindex\toffset\tlast_state\tinitia\tdeck"
  
  r.each{|v|
    diff, idx, data = v.values
    nearestp = idx == nearest_index
    idx_str = (nearestp ? "*[%03d]*" : "[%03d]") % [idx]
    offset = data[:offset]
    initiative = data[:opening][:initiative]
    # idを強調表示
    deck = "[" + data[:opening][:deck].map{|id|
      s = id.to_s
      s = "*#{s}*" if $option[:highlight_cards].include?(id)
      s = "**#{s}**" if $option[:strong_highlight_cards].include?(id)
      s
    }.join(", ") + "]"
    state = data[:opening][:last_state]
    puts "%+3d\t%s\t%+d\t%08x\t%s\t%s" % [diff, idx_str, offset, state, initiative, deck]
  }
end

def fuzzy2str(fuzzy)
  r = []
  r << t("fuzzy.ranks") if fuzzy.include?("r")
  r << t("fuzzy.order") if fuzzy.include?("o")
  r.empty? ? t("fuzzy.strict") : r.join(", ")
end

# レアカード探索
def rare_search(state: nil, player: nil, countingp: false)
  last_incr = rare_timer(state: state, player: player)
  loop {
    puts ""
    puts t("prompt.rare_search")
    line = Readline.readline($option[:prompt], true)
    case line[0]
    when nil then
      rare_search(state: state, player: player, countingp: countingp)
    when "h"
      show_pattern_help()
    when "q"
      exit
    else
      recovery_pattern = str2pattern(line, fuzzy_ranks: false)
      next if recovery_pattern.nil?
      
      next_search_type = countingp ? :counting : :recovery
      recovery_scanner = opening_scanner(state: state, player: player, search_type: next_search_type, incr: last_incr)
      start_search(scanner: recovery_scanner, pattern: recovery_pattern, player: player)
    end
  }
end

# 通常探索
def start_search(scanner: nil, pattern: nil, player: nil)
  result = []
  # fuzzyオプションを順番に適用
  $option[:fuzzy].each_with_index{|fuzzy, i|
    fuzzy_ranks = fuzzy.include?("r")
    fuzzy_order = fuzzy.include?("o")
    puts "-" * 60
    puts t("fuzzy.fmt") % [fuzzy2str(fuzzy)]
    
    # パターンの元文字列からパターンを作り直す
    pattern = str2pattern(pattern[:str], fuzzy_ranks: fuzzy_ranks, silent: true)
    puts pattern2str(pattern)

    r = scanner.(pattern, fuzzy_order: fuzzy_order)
    msg = "#{r.empty? ? "not" : r.size} found."
    (i == $option[:fuzzy].size - 1).tap{|lastp|
      msg << " retry..." if r.empty? && !lastp
    }
    puts msg
    # 見つかれば終了
    if !r.empty?
      output_search_result(r)
      result = r
      break
    end
  }
  
  loop {
    puts ""
    puts t("prompt.after_normal_search")
    line = Readline.readline($option[:prompt], true)
    case line[0]
    when nil                    # *[index]*を選択
      target = result.min_by{|v| [v[:diff].abs, v[:diff]] }
      if target.nil?
        puts t("no_target")
        next
      end
      
      last_state = target[:data][:opening][:last_state]
      rare_search(state: last_state, player: player)
    when "h"
      show_pattern_help()
    when "q"                    # 終了
      exit
    else                        # 再入力
      new_pattern = str2pattern(line, fuzzy_ranks: false)
      next if new_pattern.nil?

      start_search(scanner: scanner, pattern: new_pattern, player: player)
    end
  }
end

# スクリプトの引数からカード乱数の状態に変換
# search_type:
# - first	カード乱数の状態を連射で開始する1戦目で特定する
# - recovery	カード乱数の状態が間違いなく特定されている
# - counting	カード乱数の状態が消費回数の指定によって恐らく指定されている
def read_argv(argv, silent: false)
  tbl = [:unused, :elastoid, :malboro, :wedge]
#   tbl = {
#     { key: :unused,   name: "初期値", },
#     { key: :elastoid, name: "インビンシブル", },
#     { key: :malboro,  name: "モルボル", },
#     { key: :wedge,    name: "ウェッジ・ビッグス", },
#   ]
  s = argv[0]
  count = 0

  case s
  when "0", "1", "2", "3" # "0".."3"
    idx = s.to_i
    state_key = tbl[idx]
    msg = \
    if state_key == :unused
      t("read_argv.#{state_key}")
    else
      t("read_argv.pattern_fmt") % [$option[:early_quistis].capitalize, t("read_argv.#{state_key}")]
    end
    msg = t("read_argv.select_fmt") % [msg]
    first_state = Early_Quistis_State_Table[$option[:early_quistis]][state_key]
    search_type = :first
    msg = "%s: 0x%08x" % [msg, first_state]
  else
    # 0..3でなければそのままstateとして用い、レアカード探索モード
    first_state = s.to_i(16) & 0xffff_ffff
    search_type = :recovery
    msg = t("read_argv.direct_rng_state_fmt") % [first_state]
  end
  
  state = first_state
  if argv[1]
    count = argv[1].to_i
    state = count.tap {|n|
      rng = Card_RNG.new(first_state)
      n.times { rng.get }
      msg << "\n" + t("read_argv.advanced_rng_fmt") % [n , rng.state]
      break rng.state
    }
    search_type = :counting
  end
  puts msg if !silent
  [first_state, state, count, search_type]
end

def show_help
  puts t("help.first")
#   print t("help.continue")
#   STDIN.gets
  puts ""
  puts t("help.last")
end

def show_pattern_help
  puts t("help.pattern")
end

def main
  # 引数がなければヘルプを表示して終了
  if ARGV.empty?
    show_help()
    exit
  end
  
  # 第一引数でstateを選択し、第二引数でカウントを指定
  first_state, state, count, search_type = read_argv(ARGV)
  
  case search_type
  when :first
    loop {
      puts ""
      puts t("prompt.second_game_method")
      line = Readline.readline($option[:prompt], true)
      case line[0]
      when "h"
        show_pattern_help()
      when "q"
        exit
      else
        pattern = str2pattern(line)
        next if pattern.nil?
        scanner = opening_scanner(state: state, player: $option[:player], search_type: :first)
        start_search(scanner: scanner, pattern: pattern, player: $option[:player])
      end
    }
  else
    loop {
      puts ""
      puts t("prompt.first_game_method")
      line = Readline.readline($option[:prompt], true)
      case line[0]
      when "h"
        show_pattern_help()
      when "q"
        exit
      else
        rare_search(state: state, player: $option[:player], countingp: search_type == :counting)
      end
    }
  end
end

main()
