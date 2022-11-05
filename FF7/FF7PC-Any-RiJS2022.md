[RiJS2022](https://horaro.org/rtaij/rtaijs2022)のるぱんさんのルートにだいたい沿うよう修正。

カームカット導入前→現在のルートのPC Any%戦略の変化を「<strike>打ち消し線</strike>→変化した内容」という形で表しています。[RiJS2022採用決定後の2022/06/30にあったルート更新](#rijs2022採用決定後のルート更新関連)による変化を表しているわけではない点に注意。

元: [AGDQ2021向け解説テキスト](./FF7PC-Any-AQ2021.md)

----

<!-- TOC depthFrom:1 depthTo:3 insertAnchor:false orderedList:false -->

- [FF7 PC Any&#x025;解説?](#ff7-pc-anyx025解説)
  - [FF7について](#ff7について)
  - [PC Any&#x025;カテゴリのルール](#pc-anyx025カテゴリのルール)
  - [使用される？バグ](#使用されるバグ)
    - [RiJS2022採用決定後のルート更新関連](#rijs2022採用決定後のルート更新関連)
  - [流れ](#流れ)
    - [壱番魔晄炉](#壱番魔晄炉)
    - [八番街スラム・列車内部・七番街](#八番街スラム・列車内部・七番街)
    - [ウォールマーケット](#ウォールマーケット)
    - [下水道・列車墓場・七番街プレート](#下水道・列車墓場・七番街プレート)
    - [五番街・ウォールマーケット](#五番街・ウォールマーケット)
    - [神羅ビル](#神羅ビル)
    - [カーム](#カーム)
    - [湿地突破・デバッグルームへ](#湿地突破・デバッグルームへ)
    - [チョコボ捕獲](#チョコボ捕獲)
    - [デバッグルームへ](#デバッグルームへ)
    - [デバッグルーム](#デバッグルーム)
  - [おまけ: PC Any&#x025;のブレイクスルー(カームカット発見前まで)](#おまけ-pc-anyx025のブレイクスルーカームカット発見前まで)
  - [参考](#参考)

<!-- /TOC -->

----

- 1個あたり80Gの手榴弾をメイン火力として進む。
  - <strike>最新の戦略ではお金が**カッツカツ**なので、手榴弾を節約したり換金アイテムを細々拾いながら進んでゆく。</strike>→セブンスヘブンをスキップしないことで、2,250G≒手榴弾28個の余裕が生まれた！
- Any%で様々なスキップ技を使用すると、<strike>**レッドXIII以外命名できない**。</strike>レッドXIIIとティファ以外命名できない。
  - クラウド: アバランチスキップをすると<strong>元ソルジャー(EX-SOLDIER)</strong>のまま。
  - バレット: アバランチスキップをするとバレットのまま。
  - ティファ: <strike>セブンスヘブンスキップによりティファのまま</strike>→セブンスヘブンスキップしないので命名可能。
  - エアリス: 警備員スキップによりエアリスのまま。

***手榴算表:***
|アイテム|価格|手榴弾換算|備考|
|:---:|:---:|:---:|:---:|
|初期所持金|240G|3手榴弾||
|ポーション売却|25G|0.3125手榴弾||
|警備兵*2撃破|20G|0.25手榴弾||
|フェニックスの尾売却|150G|1.875手榴弾||
|ガードスコーピオン撃破 |100G|1.25手榴弾|ドロップ(アサルトガン)込みで270G=3.375手榴弾|
|アサルトガン売却|170G|2.125手榴弾||
|壱番魔晄炉任務報酬|1,500G|**18.75手榴弾**|<strike>セブンスヘブンをスキップするAny%最新戦略では、初心者の館のエーテルともども回収できない(-2,250G=**-28.125手榴弾**)</strike>→できる！|
|ウォールマーケット用|280G|3.5手榴弾|定食屋70G+宿屋10G+宿屋の景品200G|
|エーテル売却|750G|**9.375手榴弾**||
|アプス撃破|253G|3.1625手榴弾|ドロップ(フェニ尾)込みで403G=5.0375手榴弾|
|ハイポーション売却|150G|1.875手榴弾|フェニ尾と同じ|
|レノ撃破|500G|6.25手榴弾|ドロップ(エーテル)込みで1,250G=15.625手榴弾|
|ジンクバッテリー購入|300G|3.75手榴弾|3個中1個(100G=1.25手榴弾)は使わない|

----

# FF7 PC Any&#x025;解説?

## FF7について

- スクウェア(現スクウェア・エニックス)の『ファイナルファンタジー』シリーズの7作目。
- PS版が1997/01/31に発売された。
  - 新ウェポンなどが追加されたインターナショナル版は1997/10/02。
  - PC版の英語版は2012/08/14に発売。
  - PS4でリリースされたリメイク版は2020/04/10に発売。SGDQ2020で走られた。
- 以下が特徴？
  - FFシリーズ伝統のアクティブタイムバトル
  - 武器や防具に**マテリア**をセットすることでさまざまな効果を生み出せる、非常に自由度の高いマテリアシステム。
  - 敵からダメージを受けることでリミットゲージがたまり、ゲージが満タンになる(リミットブレイク)とキャラ固有の**リミット技**を使える。
  - ゴールドソーサーでさまざまなミニゲームを遊べる。シナリオを進める中でもミニゲームがある。
- PC版の特徴
  - アチーブメント、いわゆる実績の実装
  - 高解像度でプレイ可能
  - ゲームブースター実装
  - 修正されたバグもあるが、新たに生まれたバグも……

## PC Any&#x025;カテゴリのルール

Any% (Free FPS)のルールは[Final Fantasy VII - speedrun.com](https://www.speedrun.com/ff7/full_game#Misc.)より

> - Timing is from "New Game" until final damage on Sephiroth
> - Hard Reset before every run*
> *Soft-Resets ("New Game" after "Game Over") retain certain RAM Values from the game and "Pre-New Game Manipulations" would be possible. This accesses game breaking glitches like the Emerald Weapon Glitch or changing steproute, which are prohibited.
- "New Game"からセフィロスに最後のダメージを与えるまでを計測
- 走る前にハードリセットを行う

ソフトリセット(ゲームオーバー後の"New Game")は特定のメモリの値が持ち越され、ニューゲーム前調整を可能とする。これは、禁止されているエメラルドウェポングリッチやエンカ歩数変更など、ゲームを破壊するグリッチにアクセスする。

[Any%のルール](https://www.speedrun.com/ff7/full_game#PC)はfpsの表示が必須・Streamの英語版のみなど、より厳しくなっている。

## 使用される？バグ

PC版限定で使える**Battle Mode Warp**が非常に強力。[デバッグルーム](https://tcrf.net/Final_Fantasy_VII/Debug_Room)へ行くことができ、デバッグルームであんなことやこんなことができてしまう。PS版でデバッグルームへ行くには、チートコードを使ったりアニメティカでセーブデータを弄ったりする必要がある。

- アバランチスキップ(Abalanche Skip)
  - [Final Fantasy VII Speedruns: How to skip naming Cloud and Barret(C/B Skip) - YouTube](https://www.youtube.com/watch?v=ET2hebKZ3S4)
- ジェシースキップ(Jessie Skip)
  - [Final Fantasy VII - Buffered Jessie Skip tutorial - YouTube](https://www.youtube.com/watch?v=piQLRnJTHRw)
- 警備員スキップ (Guard Skip, Tsunaskip, Sector 7 Skip)
  - [FFVII Easy, Simple and Consistent Guards Skip Tutorial (Subtitled) - YouTube](https://www.youtube.com/watch?v=WwmbXbYKgm0)
  - [FF7　警備員スキップ - ニコニコ動画](https://www.nicovideo.jp/watch/sm33586060)
  - [裏技・バグ/【警備員すり抜け】 - ファイナルファンタジー用語辞典 Wiki*](https://wikiwiki.jp/ffdic/%E8%A3%8F%E6%8A%80%E3%83%BB%E3%83%90%E3%82%B0/%E3%80%90%E8%AD%A6%E5%82%99%E5%93%A1%E3%81%99%E3%82%8A%E6%8A%9C%E3%81%91%E3%80%91)
- 酒場スキップ(Bar Skip)
  - [Bar Skip Tutorial [FF7 Speedrun Technique] - YouTube](https://www.youtube.com/watch?v=gL5zQjC6218)
- バレットスキップ(Barret Skip)
  - [Final Fantasy VII - Barret Skip Tutorial - YouTube](https://www.youtube.com/watch?v=Lbf6NGBdQdU)
- <strike>神羅屋敷スキップ(Mansion Skip)→カーム回想をそこまで進めなくなったので使わなくなった</strike>→カーム自体に寄らなくなった。
  - [FF7 Mansion Skip Tutorial Revised - YouTube](https://www.youtube.com/watch?v=7RZDlJA4S6Y)
- <strike>ミドガルズオルムスキップ(Zolom Skip)</strike>→カームカットでチョコボに騎乗することになったため、チョコボなしでの蛇避けは不要となった。
  - [FF7INT　蛇避け　へびよけ　ミドガルズオルム避け① - ニコニコ動画](https://www.nicovideo.jp/watch/sm31060230)
  - [Midgar Zolom save glitch | Final Fantasy Wiki | Fandom](https://finalfantasy.fandom.com/wiki/Midgar_Zolom_save_glitch)
  - [Skipping the Midgar Zolom scene glitch | Final Fantasy Wiki | Fandom](https://finalfantasy.fandom.com/wiki/Skipping_the_Midgar_Zolom_scene_glitch)
- 通常バトルモードワープ(Ordinary Battle Mode Warp)
  - [裏技・バグ/【バトルモードワープ】 - ファイナルファンタジー用語辞典 Wiki*](https://wikiwiki.jp/ffdic/%E8%A3%8F%E6%8A%80%E3%83%BB%E3%83%90%E3%82%B0/%E3%80%90%E3%83%90%E3%83%88%E3%83%AB%E3%83%A2%E3%83%BC%E3%83%89%E3%83%AF%E3%83%BC%E3%83%97%E3%80%91#EBMW)
- 拡張バトルモードワープ(Extended Battle Mode Warp)
  - [裏技・バグ/【バトルモードワープ】 - ファイナルファンタジー用語辞典 Wiki*](https://wikiwiki.jp/ffdic/%E8%A3%8F%E6%8A%80%E3%83%BB%E3%83%90%E3%82%B0/%E3%80%90%E3%83%90%E3%83%88%E3%83%AB%E3%83%A2%E3%83%BC%E3%83%89%E3%83%AF%E3%83%BC%E3%83%97%E3%80%91#OBMW)
  - [FF7 Debug Room Warping Glitch (PC only) - YouTube](https://www.youtube.com/watch?v=CzbuABYClaE)
- デバッグルーム(Debug Room)
  - [Final Fantasy VII/Debug Room - The Cutting Room Floor](https://tcrf.net/Final_Fantasy_VII/Debug_Room)
- <strike>写真スキップ(Picture Skip, Photo Skip): カーム回想中に全滅するため、セフィロス抜きで戦闘に入れる写真スキップを導入するようになった……かも？</strike>→カーム自体に寄らなくなった。
  - [FF7: How to perform Photo skip - YouTube](https://www.youtube.com/watch?v=Er6HMhmJ03A)

### RiJS2022採用決定後のルート更新関連

RiJS2022採用決定が2022/06/26、本番が8/13。

2022/06/30にchuky氏の公開した[Reactor wrong warp saving](https://www.youtube.com/watch?v=evpZ7xow5F8)。これによってPC Any%のルートが更新され、[PC - Any%, No Turbo, No SCM](https://www.speedrun.com/ff7/full_game#PC)カテゴリのWRがzergu12氏の[1h41m43s](https://www.speedrun.com/ff7/run/yw3gdd3m)→同氏の[1h36m46s](https://www.speedrun.com/ff7/run/y88g7qxy)と約5分短縮された。

PC Any%でのデバッグルームへのバトルモードワープには、長らく「カームの街での回想中の戦闘」が利用されてきたが、それが「壱番魔晄炉脱出中の戦闘」でも可能であると判明し、ルートが更新された。その結果、カームの街へは全く寄らなくなった。

カームカット(Kalm Skip)の方法が、簡単な[Kalm Skip 2](https://www.youtube.com/watch?v=ohf9W4boGr8)から、難しい[Chocobo glitch](https://www.youtube.com/watch?v=vCRn5_ZTv7U)を含む発見当初の[Kalm Skip 1](https://www.youtube.com/watch?v=y_uUpSSYc4M)に戻ったのだから面白い(外野の気楽な意見)。

- Chocobo glitch (Chocolom)
  - [Chocobo glitch setup with Zolom for Kalm skip (read description) - YouTube](https://www.youtube.com/watch?v=vCRn5_ZTv7U)
- Kalm Skip 1
  - [Final Fantasy VII - Kalm Skip shortcut setup (Update in description) - YouTube](https://www.youtube.com/watch?v=y_uUpSSYc4M)
- Solo Cloud
  - [Cloud Solo Midgar Escape Glitch - YouTube](https://www.youtube.com/watch?v=JOogcYxo2Ds)
- Reactor wrong warp saving
  - [FF7 Reactor wrong warp saving - YouTube](https://www.youtube.com/watch?v=evpZ7xow5F8)
  - [FF7 More information about the Reactor wrong warp - YouTube](https://www.youtube.com/watch?v=HgpuKeTc63E)

なお、チョコボを使わない(!?)[さらなる高難易度ルート](https://www.youtube.com/watch?v=7wT7xspDGIg)まで開発されている。これによって7/24にはthemattdavis氏の[Any%, Turbo, No SCMカテゴリ1:34:44](https://www.youtube.com/watch?v=PO-d9dYZPTQ)という記録が達成されている。

## 流れ

### 壱番魔晄炉
- 最初にやるのはコンフィグ変更
  - カーソル: しょきか→きおく
    - 同じコマンドを素早く連続で入力するため
  - ATB: おすすめ→アクティブ
    - **常に**ATBバーが進む。
    - 一部の戦闘では「ウェイト」に変更する。ウェイトではコマンド窓を開いたり魔法演出中はATBバーが止まる。
  - バトルスピード: 左端(最速)
    - ATBバーの進みが速くなる。戦闘がサクサク進むが、コマンドにもたつくと危ない。
    - <strike>危険なウェポン戦では右端(最遅)に変更する。</strike>→Any%では関係なし
  - バトルメッセージ: 左端(最速)
  - フィールドメッセージ: 左端(最速)
- 駅員からはポーションを2個拾える
- 戦闘: 警備兵(HP: 30)*2
  - ○長押しで2回殴れば終わり。
- 次のマップで**アバランチスキップ(Abalanche Skip)**
  - クラウドとバレットの名前入力をスキップできる。リカバリが困難で難しい。約20sの短縮。
  - クラウドの名前はずっと<strong>元ソルジャー(EX-SOLDIE)</strong>となる。
  - 本来Lv6で加入するバレットが**Lv1**で加入する。
- ランダムエンカウントは全逃げ。
  - 特定の場所でメニューを開いたり歩くことでスキップできる。詳しくはややこしいので省略！
- <strike>行きの道でフェニックス尾(売値150G)を回収*しない*。</strike>→セブンスヘブンスキップしないことで寄り道せずとも充分な手榴弾を買えるようになったため、ここらへんの換金アイテムはどーでもよくなった。
  - <strike>手榴弾を16個買いつつウォールマーケットで必要なお金を確保するため。</strike>
    - <strike>恐らく下水道のボスであるアプスへの先制攻撃調整が失敗すると大きくロスするリスキーな浅略。</strike>
  - <strike>帰りの道だとこのマップはエンカが発生するため、回収するときは行きの道で回収。</strike>
- 「かいふく」マテリアが道を塞いでいるので回収
- ボス戦: ガードスコーピオン(HP: 800)
  - サーチ→サーチしたキャラに攻撃
  - しばらく経つと尻尾を上げる。この状態のときに攻撃すると、カウンターで全体攻撃のテイルレーザーを行う。
  - クラウドはサンダー、バレットは打撃。リミットブレイクしたらリミット技？
    - リミットゲージはATBバーの左側。リミットブレイクするとATBバーが爆速で伸びる。
  - アサルトガン(バレットの武器、売値170G)を落とす。
- ガードスコーピオンを撃破したら時限爆弾がセットされる。来た道を戻って脱出する。
  - 10分以内に脱出できなければゲームオーバー！
- Reactor Wrong Warp Savingに使う用のセーブデータを帰り道で作る。
  - のちに速やかに全滅するためガードスコーピオン戦でパーティのHPを減らしておく。
- アプス戦で先制攻撃を行うための仕込みを行う。
  - 先制攻撃を取れると、ブレイバーで通常の**4倍**のダメージを与えられるため。戦闘時間短縮と手榴弾節約を兼ねて。
- 帰り道、ジェシーが足を挟んで動けなくなっているのでポーションを拾いつつ助ける。
  - ジェシーがいないと帰りの扉を開けない！

### 八番街スラム・列車内部・七番街
- 花売りエアリスと会う
  - まだ仲間にはならない。
- 八番街スラムを下に進むと、警備兵に追いかけられる
  - 選択肢は全て下を選んで戦闘を回避。上を選ぶ or 何も選ばないでいると、戦闘が始まってしまう。
- 列車内部で**ジェシースキップ(Jessie Skip)**
  - 前に来すぎると手前から車掌が飛び出してくるが、これと同時にジェシーに話しかける。
  - 会話中にマップを切り替えることで会話の一部をスキップする。約10sの短縮。
- <strike>**セブンスヘブンをスキップ**する。</strike>→チョコボを捕まえるために必要な「チョコボよせ」マテリアの装着がカームカットで必須となるので、スキップしない！
  - <strike>5分の短縮になるが、以下のデメリットがある。</strike>
    - <strike>マテリアを装着できなくなる。</strike>→できる
    - <strike>**壱番魔晄炉撃破の給料1500Gが回収できない。**</strike>→できる
    - <strike>**初心者の館のエーテル(売値750G)を回収できない。**</strike>→できる
  - <strike>つまり1500+7500=2250Gを失うことになる。実に**手榴弾約28個分**である。</strike>→手榴弾28個分の余裕ができる。ちまちま換金アイテムを拾う必要がなくなったし、神羅ビルで「非常階段」よりも手榴弾の消費が増えるがタイム短縮になる「正面突破」を選択できる！
    - <strike>手榴弾節約のため、ボス戦でHPの端数は打撃や魔法やリミット技で削る。</strike>→これはする？
    - <strike>また手榴弾購入資金の捻出のため、細かい換金アイテムをいろいろ回収する。</strike>→しない
- 起床後、バレットにマテリアの解説を催促されるが、2番目の選択肢「面倒くさい……」を選択する。
  - 「面倒だが説明しよう」を選択すると大きなロスになる。
- 右下の武器屋で**手榴弾**を買う
  - 今後デバッグルームに入るまで、攻撃手段は手榴弾がメイン。140前後の大ダメージ・確定命中・後列からでも与ダメ減らない・モーション短い・アイテムなので誰でも使える。ただし1個につき80Gで、数に限りがある。
  - ウォールマーケットで**280G**必須なので残しておく。
- **警備員スキップ(Guard Skip)**
  - 七番街の下の警備員をすり抜ける。
  - 伍番街魔晄炉爆破～エアリス加入～六番街公園のイベントをまるごとスキップ。実に約15mの短縮。
  - エアリスが本来Lv2で加入するところ、Lv1加入になる。

### ウォールマーケット
- スキップされたシナリオの説明
  1. 伍番街魔晄炉を試みる
  1. エアバスターを撃破するも、クラウドだけ通路から落下する
  1. 落ちた先のスラムの教会でエアリスと出会い、ボディガードとしてタークスから逃げエアリスの家まで送る
  1. 七番街へ行くべくエアリスの家から自分だけ抜け出すも、エアリスがついてくる
  1. 六番街公園でティファらしき人物が馬車に乗っているのを見かける
- コルネオの館へ潜入するため店を回って女装するイベント
  - クラウド以外が選ばれると余計な戦闘が発生してロスになるので、クラウドが選ばれるようにする。
1. マテリアショップの店員に話しかける
1. ブティックの店員に話しかける
1. 定食屋で薬屋商品クーポンを入手。3回目の選択肢は2番目の「まあまあだな」
1. 薬屋で、消化薬を入手。選択肢2番目
1. 宿屋で泊まり、200ギルの物を買う
1. マテリアショップの店員に話しかけ、ダイヤのティアラを入手
1. 酒場の奥のトイレに入っている人物に2回話しかけ、セクシーコロンを入手
1. 酒場入口付近にいるオヤジに話しかけ、選択肢2番目の「さわっとしたの」と2番目の「つやつやしたの」を選ぶ
  - 酒場スキップ(Bar Skip)
    - トイレの人物とオヤジの会話を同時に行い、約10s短縮する。
    - ソフトロックと隣り合わせの危険な技でもある。
1. ブティックでオヤジに話しかけ、シルクのドレスを入手
1. 男の館でスクワット勝負に勝利し、ブロンドのかつらを入手。選択肢は2番目の「わかった」、2番目の「練習など必要ない」
  - □×○を順番に押すだけ。PC版だと最高22回？
1. ブティックの試着室に入り、女装完了
- コルネオの館おしおき部屋にティファがいる。エーテルも忘れずに回収。
- 女装イベントをしっかりこなしていればクラウドが選択される。
  - クラウド以外が選択された場合、別室でコルネオの子分との戦闘になる。
- コルネオの寝室での選択肢は2番目の「え～と……」、2番目の「バレットっていうの……」
  - ベッドの裏には興奮剤(売値50G)がある。

### 下水道・列車墓場・七番街プレート

- ティファとエアリスに話しかけるとアプス戦。
  - アプス戦で先制攻撃を行えるセットアップがある！
- ボス戦: アプス(HP: 1,800)
  - `140(手榴弾)*3 + 480(4倍ブレイバー) + 185(下水津波) + 140(手榴弾)*4 + 185(下水津波) = 1830 > 1800`
  - 先制攻撃で全員手榴弾投げ→クラウドのブレイバー。
    - ブレイバーの与ダメが通常の**4倍**になる。手榴弾節約＆時間短縮。
  - 全体攻撃の「下水津波」は、アプス自身にもダメージが入る。
  - 「なめる」をされるとかなしい状態になる。
    - かなしい状態ではリミットゲージの貯まる量が半減するものの、被ダメージが**3割**減る。<strike>ウェポン戦では鎮静剤を使いまくってかなしい状態にする。</strike>→PC Any%ではほぼ関係なし
  - フェニックスの尾(売値150G)を落とす。
- 列車墓場ではハイポーション(売値150G)を回収。
  - 上のマップでは2台の列車に入って道を作る。<strike>少し右上に寄り道してハイポーション(売値150G)を回収する。</strike>→寄り道するほどの価値ではない
- 七番街プレート
- ボス戦: タークス：レノ(HP: 1,000)
  - クラウドで1回殴って手榴弾を1個節約する
    - `40(クラウドの打撃) + 140(手榴弾)*7 = 1020 > 1000`
  - ピラミッドを喰らうと行動不能になる。
  - 電磁ロッドはマヒの追加効果。
  - エーテル(売値750G)を落とす。
- いろいろ操作してイベントを進む。

### 五番街・ウォールマーケット

- クラウド1人だけだが、少し下に進むとバレットとティファも加入する。
- エアリスの家の右でエーテル(売値750G)回収
- エアリスの家で長いイベントを見る
  - <strike>見終わったら、2Fでポーション(売値25G)とフェニックスの尾(売値150G)</strike>→寄り道するほどの価値ではない
- 五番街武器屋で買い物
  - あらかた売却
  - ジンクバッテリー購入用の**300G**を残し、買えるだけ手榴弾を買う。
- ウォールマーケットでジンクバッテリーを買う
- 壁をジンクバッテリーをはめながら進む。
- タイミングよく○ボタンを押して振り子を掴んで進む。

### 神羅ビル
- <strike>59Fまで、正面突破と非常階段の2通りあるが、非常階段を登る。</strike>→セブンスヘブンで受け取った給料のお陰で手榴弾は潤沢なので、タイムがより短縮される正面突破！
  - <strike>恐らく手榴弾を節約するため。</strike>
- メニュー操作を行う
  - ATBをウェイトに変更する
    - 59Fの強化戦闘員戦と、68Fのサンプル戦に向けた準備。
    - 敵が多い場合、ATB設定アクティブだと敵に動きまくられるが、ウェイトにして時間の進み方を工夫すれば敵の行動回数を抑えられる。
  - 全員の隊列を後列にする。
    - 後列だと物理与ダメージ被ダメージともに半減する。
    - リミット技やバレットの通常攻撃など、一部の攻撃のダメージはそのまま。
- 59F
  - 戦闘: 強化戦闘員(HP: 230)*3
    - ATBウェイトの戦い方。なるべく2人分のATBを同時に進ませることで、敵のATBバーの進みを抑える。
    - ATBバーの上の文字列がTIMEから**WAIT**になっているとATBバーが進まない。
  - まっすぐ右に進まずにやや下から戦闘に入っているのは、このフロアで戦闘後に歩く距離を抑えるため。
    - このフロアで戦闘後にランダムエンカを踏むと、**逃げることができない**。
- 60F
  - 神羅ビル名物かくれんぼ。
    - 右側の兵士の動きが速い。
    - 見つかると強化戦闘員*2のはさみうちを喰らい、手榴弾を4個消費させられる。
- 61F
  - 下の男に話し掛け、選択肢2番目「……………」を選ぶとカードキー62入手。
- 62F
  - ドミノ市長のクイズに正解してカードキー65を入手。
    - 間違えた回数が少ないほどいいアイテムが手に入るが、特に必要なものはないし何度でも挑戦できるので適当に答える。
      - フロアに入る直前のゲーム内時間から正解を特定することもできる。
    - 英語の選択肢: BEST, KING, ORBS, BOMB, MAKO, HOJO
    - 日本語の選択肢(全て**四字熟語**): 魔晄爆発!!・市長最高!!・魔晄最高!!・神羅爆発!!・市長爆発!!・神羅最低!!
- 65F
  - 適切な順番で宝箱を開けながら中央の模型にミッドガルパーツをはめてゆく。
    1. 左上部屋の下宝箱
    1. 左下部屋の上宝箱
    1. 左上部屋の上宝箱
    1. 左下部屋の下宝箱
    1. 右上部屋の宝箱
    1. 階段部屋の宝箱からカードキー66を入手
- 66F
  左上のトイレから天井裏に登り、会議を盗み見る
- 67F
  - ジェノバを見て頭がキーンてなるイベント
  - 毒マテリアは拾わない
    - マテリアキーパーとパルマーを撃破していた2020年6月以前の戦略では拾っていた
- 68F
  - レッドXIII加入
  - ボス戦: サンプル：HO512(HP: 1,000) + サンプル：H0512-OPT(HP: 300)*3
    - <strike>クラウドのブリザドまたはレッドXIIIのファイアを使い、手榴弾を1個節約する</strike>→しない
      - <strike>`90(魔法) + 137(手榴弾)*7 = 1049 > 1000`</strike>
    - 本体を撃破すればお供も消えるので、本体だけ狙う
    - 怪しい息は全体毒効果だが特に問題ない。
    - お供のファイアやブリザドが痛い。
    - タリスマン(精神+10のアクセサリ、売値2000G)を落とす
  - てきのわざマテリアは拾わない
  - メニュー操作
    - ATB設定ウェイトからアクティブへ変更
      - ウェイトのままだとランダムエンカウントから逃げにくいため
    - レッドを後列へ
  - 66F外観エレベーターの操作盤を調べたら、ルードに捕まる
- プレジデント神羅に謁見
- 独房で一眠り
- 起床すると見張り兵が死んでいる。70Fまで進むとプレジデント神羅も死んでいる。
- ヘリポートに出てルーファウスと話すと、操作パーティがクラウド以外に移る。
  - クラウドのマテリアを外す選択肢は2番目の「はずさない」を選択
- 外観エレベーターの操作盤を調べるとボス戦
- ボス戦: ハンドレッドガンナー(HP: 1,200)→ヘリガンナー(HP: 1,000)
  - `140(手榴弾)*12 = 1680 > 1600`
  - `140(手榴弾)*8 = 1120 > 1000`
  - ハンドレッドガンナーを倒すとヘリガンナーと連戦。
  - ヘリガンナーのAB砲と全体攻撃の一斉射撃は睡眠追加効果があるのでロス要素。
  - ミスリルの腕輪(防具)を落とす。
- ヘリガンナーを撃破したら操作がクラウドに移る
  - 選択肢はSTARTボタンで即終了
- ボス戦: ルーファウス(HP: 500) + ダークネイション(HP: 140)
  - `145(手榴弾)*4 = 580 > 500`
  - ダークネイション→ルーファウスの順に処理する。
    - ダークネイションが手榴弾一発で落とせるかどうかは乱数次第。
  - ダークネイションは初手でルーファウスにバリア(物理ダメージ半減)を張るが、手榴弾の前には無力。
  - 防弾チョッキ(体力+10のアクセサリ)とガードアップを落とす。
- 69Fのティファに話し掛け、操作が移ったエアリスのパーティでビルを出る
- いろいろできるが、STARTボタンを押してGバイク開始
  - トラックに乗っている仲間の被ダメージがそのままモーターボール戦に引き継がれるので、なるべく被ダメージを受けたくない
   - 敵バイクは同時に最大で3台までしか出現しない
   - 赤のバイクは、クラウドが武器を振り回しているとクラウドに接近してこない
   - というわけで、赤のバイクを3台揃え、かつクラウドがトラックの後ろで武器を振り回し続けていれば、ダメージを受けなくなる。
  - PS版は○ボタン長押しで剣を振り続けてくれたのに、PC版は手動連打しないと振り続けてくれない。
- ボス戦: モーターボール(HP: 2,600)
  - 起き上がるまで: `210(サンダー)*5 + 145(手榴弾)*8 = 2210 <= 2275`
    - `210(サンダー)*6 + 145(手榴弾)*10 = 2710 > 2600`
  - 以下のローテーション。ただし、モーターボールのHPが1/8(325)以下になると起き上がり、ローテ位置が3番目(c)へ変更される。
    1. 最もHPの高いキャラに1回または2回アームアタック
    1. ↑と同じ
    1. うつ伏せになり、ツインバーナー
    1. 待機
    1. デッドリーホイール(技名は表示されない)
    1. 起き上がる
    1. ローリングファイア(全体に大ダメージなので撃たせてはならない)
  - 7番目(f)の「起き上がる」がローテ位置変更によって「ツインバーナー」に変更されないようにするため、**「起き上がる」までの与ダメを2275未満に抑えつつ、かつそのターンでHPを削り切る**戦術が取られている。
  - 星のペンダント(毒を防ぐアクセサリ)を落とす
- ワールドマップに出る直前で<strong>バレットスキップ(Barret Skip)</strong>を行う
  - バレットとの会話とワールドマップに出ようとしたときの会話を同時に行うことで、会話の途中で外に出る。約30sの短縮。

<strike>

### カーム

- 北東にあるカームの街に入る
- 回想に入る
- 戦闘: ドラゴン
  - セフィロスがアレイズを使わないよう祈る
- ニブルヘイム宿屋2Fのセフィロスに話しかける
- 写真撮影が行われる
  - Picture Skipというものがあるが、PC版でやるとソフトロックが発生する
- ティファを追って吊り橋を進むと吊り橋が切れる
- 会話を進めながら魔晄炉へ進む
- バルブを閉じてセフィロスに話し掛けたら一時休憩
  - この時の**セーブ**が重要。
- 神羅屋敷地下の研究室でセフィロスの独り言を聞く
- 神羅屋敷2Fで起きたら、神羅屋敷地下の書斎に入る
- 神羅屋敷を出たら街が燃えている。クラウドの家に入る
- 魔晄炉の中を進むと回想終了。
- 仲間との会話の選択肢では2番目「わかったよ」を選択する。
- 宿屋の出口でPHSを貰い、パーティが編成可能になる(しない)。
  - PHS is not Personal Handy-phone System.
  - PHS is **P**arty **H**ensei **S**ystem.

### 湿地突破・デバッグルームへ

- ミドガルズオルムのいる湿地をチョコボなしで突破する。
  - ミドガルズオルムと接触しそうになったらセーブリセットする。
- ミスリルマイン入り口前のイベントは、タイミングよくメニューを開いてスキップする。
- ミスリルマイン出口でタークスがちょろっと出てくる。
- ジュノンエリアでセーブする
  - 回想中とは違う場所に
  - 特定のゲーム内時間でセーブすることで、ロード後の1エンカ目で「**ネロスフェロス\*2フォーミュラ**」を出すことも可能。
- ゲームを再起動し、回想中セーブをロードする
- 神羅屋敷スキップ(Mansion Skip)を行う
  - 割と簡単。
- ニブル山に入ってすぐのところでエンカを起こし、全滅する
- そのまま**再起動せず**、ジュノンエリアのセーブをロードする
- 砂地でエンカを起こし、撃破する
  - 草地ではなく砂地でエンカを起こすのは恐らく、撃破しやすい単体エンカが出やすいため。
- ニブル山からの再開になる。手前からワールドマップに出て、ワールドマップでエンカを起こして全滅する
- そのまま**再起動せず**、ジュノンエリアのセーブをロードする
- 草地で「**ネロスフェロス\*2フォーミュラ**」が出現するまでエンカを起こす
  - ゲーム内時間調整済みなら、左へ走り続ける。
- 「ネロスフェロス\*2/フォーミュラ」から逃げ、砂地で次のエンカを起こして撃破すると**デバッグルームのロビー**へ！

</strike>
→カームカット導入後はまるっきり別モノ！

### チョコボ捕獲

- チョコボを捕まえるため、牧場にいるグリングリンから「チョコボよせ」マテリアを買う。2000G必須。
  - ついでにギザールの野菜(100G)も買う。
- チョコボファームから出る直前メニューを開く
  - 「チョコボよせ」マテリアを誰かに装着する
    - チョコボエンカを踏むため必須
  - ATBをウェイトに変更する
    - ATBアクティブだとチョコボにすぐ逃げられるため。
  - ゲーム内時間調整しつつ、メニューを閉じてすぐワールドマップへ出る。
- ワールドマップに出たら右に加えてR1も長押し、エンカを踏むまでぐるぐる回り続ける。
  - チョコボエンカを引く。
- チョコボエンカ
  - チョコボに野菜を投げ、逃走を防止する。
  - その間にクラウドを死なせつつ、チョコボ以外の敵を倒すとチョコボを捕獲できる。
    - クラウドを死なせるのはReactor Wrong Warp savingの準備。

### デバッグルームへ

- チョコボを捕獲したら一旦ミスリルマイン付近で降り(チョコボ逃げない)、ATBをアクティブに戻してセーフティセーブ。
  - ATBをアクティブに戻すのはミドガルズオルムからすぐ逃げたいから。
  - ここで作ったセーブは最終盤にも利用する。
- Chocobo Glitchを行う。
  - 一旦チョコボファーム側の草地に触れる。
  - ミドガルズオルムを誘導し、**チョコボがミスリルマイン側の草地に触れると同時にミドガルズオルムと接触する**。タイミングが非常にシビア。
  - 成功したら、チョコボファーム側の草地に戻されつつ(通常の挙動)、降りてもチョコボが逃げなくなる(ミスリルマイン付近での挙動)。
- ミッドガル付近でチョコボから降り、ミッドガルに入る。
- Solo Cloudを行う。
  - バレットスキップによって未達となっていたミッドガル脱出時のパーティ分けイベントが再び起動される。
  - イベント中特定のタイミングでワールドマップへ出ることにより、パーティにクラウドしかいない状態になる。
  - これにより、パーティは戦闘不能のクラウド単騎となる。この状態でエンカを踏むと、戦闘突入と同時に全滅する。
- カームカット(Kalm Skip)を行う。
  - ミッドガル南西の岬で降りる→北、東へと移動する→再び岬で降りる→なぜか川を乗り越えてジュノン側の草地に進入できる。
  - 2021/10/10にKuma氏によって発見され、FF7RTA界隈を激震させたバグ。
- セーブする。
- 再起動し、壱番魔晄炉脱出中のセーブをロードする。
- 全滅する。
- **再起動せず**、ジュノンエリアのセーブをロードする。
- 草地で「**ネロスフェロス\*2フォーミュラ**」が出現するまでエンカを起こす
  - ゲーム内時間調整済みなら、左右または上下に往復移動する。
- 戦闘開始と同時に全滅する。
- **再起動せず**、ミスリルマイン付近のセーブをロードする。
- ミドガルズオルムと接触する(なんでもいいからエンカを踏む)と、壱番魔晄炉へワープ！
  - なぜかテキストダイアログが表示された状態。
- 傍のセーブポイントでセーブする。
- 先ほどのセーブをロードすると**デバッグルームのロビー**へワープ！

### デバッグルーム

- 下のフロアへ入る
- 5時方向にいるティファに話し掛け、4番目の「LAS4-0」を**R1ボタンを押しながら**選択すると最終戦直前へワープする
  - R1ボタンを押さなければ、同じ場所だが星の体内へ降りる前の状態へのワープとなる。
- BOSS: セフィロス(HP: 1)
  - セフィロスの(HP割合)攻撃を待って自動発動のカウンターで撃破 or 能動的にリミット技で撃破。
  - バトルスピード最速の場合、ブレイバーを使って倒すと約1.5sのロス。
  - 超究武神覇斬を覚えていないのは、恐らく直前のセーファ・セフィロス戦を経ていないから。

## おまけ: PC Any&#x025;のブレイクスルー(カームカット発見前まで)

[Any% (30 FPS)カテゴリWR](https://www.speedrun.com/ff7/full_game#PC)の変遷でみるブレイクスルー。

- 2018/07/26: [2h 37m 48s by camp4r](https://www.speedrun.com/ff7/run/z115pnwz)
    - [警備員スキップ(Guard Skip)](https://www.youtube.com/watch?v=SbzQ9JuxXQw)の発見。
    - 七番街から六番街公園への道を塞ぐ警備員をすり抜けることにより、約20分の更新！
      - しかも全てのバージョンで使える！
    - 壱番魔晄炉撃破 → セブンスヘブン → 警備員スキップ → いろいろ → ジュノンエリアでセーブ → 過去ニブル山全滅 → ワールドマップエンカ撃破 → マテリアキーパー撃破 → パルマー撃破 → モーターボール全滅 → ユフィ撃破 → モーターボール撃破 → 「スペンサー*3/フラップビート」遭遇 → ワールドマップエンカ撃破→ デバッグルーム(稼ぎ2戦) → ラスト3連戦 → セフィロス撃破
- 2020/04/25: [2h 21m 06s by EmeRgency_Murse](https://www.speedrun.com/ff7/run/y4ww89qm)
    - EBMWの方法を更新(new RJ skip)。モーターボール戦を経由せずにデバッグルームへ行く。
      - 「モーターボール全滅 → ユフィ撃破 → モーターボール撃破」の部分を「ニブル山で全滅 → ワールドマップエンカ撃破」と変更。
    - 約9分の更新！
    - 壱番魔晄炉撃破 → セブンスヘブン → 警備員スキップ → いろいろ → ジュノンエリアでセーブ → 過去ニブル山全滅 → ワールドマップエンカ撃破 → マテリアキーパー撃破 → パルマー撃破 → 「スペンサー*3/フラップビート」遭遇 → デバッグルーム(稼ぎ2戦) → ラスト3連戦 → セフィロス撃破
- 2020/06/14: [2h 03m 57s by RJTheDestroyer](https://www.speedrun.com/ff7/run/m7gxxrwm)
  - ロケットタウンスキップ(発見者: PetFriendAmy)
  - デバッグルームへ行く方法を大幅に短縮。
    - 「マテリアキーパー撃破 → パルマー撃破 → ニブル山で全滅 → ワールドマップエンカ撃破」を「ワールドマップ全滅 → 「ネロスフェロス\*2/フォーミュラ」遭遇 → ワールドマップエンカ撃破」と変更。
    - **マテリアキーパー・パルマーとの戦闘がなくなった**ため、安全にもなった。
  - 壱番魔晄炉撃破 → セブンスヘブン → 警備員スキップ → いろいろ → ジュノンエリアでセーブ → 過去ニブル山全滅 → ワールドマップエンカ撃破 → ワールドマップ全滅 → ネロスフェロス\*2/フォーミュラ」遭遇 → ワールドマップエンカ撃破 → デバッグルーム(稼ぎ2戦) → ラスト3連戦 → セフィロス撃破
- 2020/06/18: [2h 01m 12s by RJTheDestroyer](https://www.speedrun.com/ff7/run/y4wxd8km)
  - セブンスヘブンスキップ
  - 警備員スキップする場合セブンスヘブンもスキップ可能とわかっていたが、セブンスヘブンをスキップすると**マテリアを装着できない**ので、マテリアキーパー戦とパルマー戦のためにセブンスヘブンへ行っていた。
  - マテリアキーパーとパルマーを倒さなくてよくなる → マテリア操作が不要 → センブンスヘブンをスキップできる！
    - ……ただし、バレットからの給料(1500G)と初心者の館のエーテル(売値750G)を回収できなくなるため、メイン火力の手榴弾(80G)が満足に買えないという問題が生まれる。
  - 壱番魔晄炉撃破 → 警備員スキップ → いろいろ → ジュノンエリアでセーブ → 過去ニブル山全滅 → ワールドマップエンカ撃破 → ワールドマップ全滅 → ネロスフェロス\*2/フォーミュラ」遭遇 → ワールドマップエンカ撃破 → デバッグルーム(稼ぎ2戦) → ラスト3連戦 → セフィロス撃破
- 2020/06/23: [1h 57m 54s by death_unites_us](https://www.speedrun.com/ff7/run/y4wgjenm)
  - ラスト3連戦スキップ
    - デバッグルームからのワープ先は「LAS4-4」で、SYNTHESIS戦直前であった
    - しかし、「LAS4-0」を**R1を押しながら**選択することで、セフィロス戦前の3戦をスキップ！
  - 壱番魔晄炉撃破 → 警備員スキップ → いろいろ → ジュノンエリアでセーブ → 過去ニブル山全滅 → ワールドマップエンカ撃破 → ワールドマップ全滅 → ネロスフェロス\*2/フォーミュラ」遭遇 → ワールドマップエンカ撃破 → デバッグルーム(稼ぎなし) → セフィロス撃破
- 2021/01現在の最速記録: [1h 51m 32s by d13sel](https://www.speedrun.com/ff7/run/z1on8krm)

----

## 参考
- [FF7 Speedruns and Research (Discord Server)](https://discord.gg/cYavTQWVTU)
- [Final Fantasy VII translations | Final Fantasy Wiki | Fandom](https://finalfantasy.fandom.com/wiki/Final_Fantasy_VII_translations) - 日英対訳表
- [Guides - Final Fantasy VII - speedrun.com](https://www.speedrun.com/ff7/guides)
- [Category:Bugs in Final Fantasy VII | Final Fantasy Wiki | Fandom](https://finalfantasy.fandom.com/wiki/Category:Bugs_in_Final_Fantasy_VII)
- [Final Fantasy VII/Debug Room - The Cutting Room Floor](https://tcrf.net/Final_Fantasy_VII/Debug_Room)
- [Final Fantasy VII - Enemy Mechanics FAQ - PlayStation - By TFergusson - GameFAQs](https://gamefaqs.gamespot.com/ps/197341-final-fantasy-vii/faqs/31903)
- [ファイナルファンタジー7 解体真書 ザ・コンプリート](https://www.amazon.co.jp/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%8A%E3%83%AB%E3%83%95%E3%82%A1%E3%83%B3%E3%82%BF%E3%82%B8%E3%83%BC7-%E8%A7%A3%E4%BD%93%E7%9C%9F%E6%9B%B8-%E3%82%B6%E3%83%BB%E3%82%B3%E3%83%B3%E3%83%97%E3%83%AA%E3%83%BC%E3%83%88-%E3%82%B9%E3%82%BF%E3%82%B8%E3%82%AA%E3%83%99%E3%83%B3%E3%83%88%E3%82%B9%E3%82%BF%E3%83%83%E3%83%95/dp/4893666789)
- [stay - niconico(ニコニコ)](https://www.nicovideo.jp/user/11984513/video) - stay氏はFF7のバグについておそらく日本で最も詳しい。
- [ファイナルファンタジー用語辞典 Wiki*](https://wikiwiki.jp/ffdic/)