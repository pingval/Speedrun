# [PS版FF7 セーブデータ改竄RTA in 28:44](https://www.twitch.tv/videos/454491953)

- プレイ日時: 2019年07月18日
- 計測区間: 本体の電源投入からエンドロゴ消滅まで
- 使用ソフト:
  - RPGツクール3
  - PS版FF7 インターナショナル版
- 使用本体: PS2(SCPH-90000)
  - FF7でディスク読み込み速度「高速」使用
- 使用コントローラ: Sony SCPH-10010
- 改ざん用のセーブデータ作成を計測区間に含める（事前に作成したセーブデータの利用は禁止！）
- アニメティカでの8ブロックセーブ中のメモリーカードの抜き差しは禁止（事前に作成したセーブデータを利用できる怖れがあるため）

----

## 戦略概要

- アニメティカで、現在のマップをエンディングの再生されるマップ(MapID: 76)に、メイン進捗度をちょうど`1999`に改竄する。現在のDISCもDISC 3に改竄する。
- FF7でNEW GAMEを選択後なるべく早くセーブし、途中でメモリーカードを引き抜く。そのデータをロードすると、セーファ・セフィロス戦後のイベントから開始される。セフィロス戦は[システムエラー](https://wikiwiki.jp/ffdic/%E8%A3%8F%E6%8A%80%E3%83%BB%E3%83%90%E3%82%B0/%E3%80%90%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E3%82%A8%E3%83%A9%E3%83%BC%E3%80%91)が発生するのでL1 + R1 + SELECTで強制終了させる。
- PS2電源投入～セーブポイント到達の区間を高速読み込みの有無で比較すると、ありのほうが4sほど速かったので高速読み込みを使用。
- メモリーカードの引き抜きタイミングは魔晄炉BGMのBPMに合わせるとちょうどいい。
- エンカ域での歩き(9歩と1エンカ後23歩)によりエンカウントを1回に抑えている。
- ソフトリセット後、DISC交換画面を待たずに「NEW GAME/つづきから」が表示されたときDISC 3に交換しながら操作すると、10sほど早くロードできる。しかしその後のムービーが正常に再生されず、エンドロゴも表示されなかったのでボツとした。メモリーカードの書き込みの途中で引き抜くなんてことをしてるカテゴリなんだから、CD-ROMの読み込みの途中で交換したっていいかもしれないが、とりあえず今回はやめておく。

### セーブデータ詳細

[セーブデータエディタBlack Chocoboのソースコード](https://github.com/sithlord48/blackchocobo/blob/master/ff7tk/data/FF7Save_Types.h)参考。以下のアドレスの中身は必須。これら以外は好きに変更して良い(はず)
```
0x4200..0x4201: 0x4204..0x52f3のチェックサム(CRC16/GENIBUS)
0x4202..0x4203: 00 00
0x46f8..0x46fa: 現在のパーティ: (x[0] != 00 || x[1] != 00) && x[2] != 00
0x4d94: 00 ;; 現在の状態？
0x4d95: 00
0x4d96..0x4d97: fb 02 ;; 現在のMapID: 763
0x4da4..0x4da5: cf 07 ;; 現在のメイン進捗度: 1999
0x50a4: 03 ;; 現在のDISC: 3
```
- チェックサムの座標は(160..161, 27)と塗りにくい位置ではないが、2byteしかなく0に調整しやすいので0に調整しておいた。
- チェックサムのアルゴリズムはCRC16/GENIBUS。crchackに渡すオプションは`-w16 -p1021 -iffff -xffff`。
- 現在のパーティは`(x[0] != 00 || x[1] != 00) && x[2] != 00`の条件を満たしていないとセフィロス戦開始直後にフリーズしてしまう(`00`はクラウドを指す。クラウドが2人以上いる扱いになるせい？)ため、少なくとも2箇所は`00`以外に変更する必要がある。いろいろなパターンがありうるのでついでにチェックサム調整に利用した。
- セーファ・セフィロス戦後のイベントから再開するには、メイン進捗度をちょうど`1999`にする必要がある。
- `0x41ff`までは書き込まれてもチェックサムに影響が及ばないので、メモリーカード引き抜き猶予時間は`2 + ((0x41ff + 1 - 0x4000) / 128).ceil = 6`の6f(たぶん)。

以下の色塗りを採用した。
```
AnimeMaker:
  03: (164, 40)
  FB: (246, 37)
  02: (247, 37..38)
  CF: (260, 37)
  07: (261, 36)
  07: (261..262, 37)
  07: (281..282, 31)
Visual:
y\x|164 ~ 246247                                    260261262                                                      281282
---+--- ~ ---------------------------------------------------------------------------------------------------------------
 31|    ~                                                                                                           07 07
   |    ~                                                                                                                
   |    ~                                                                                                                
   |    ~                                                                                                                
   |    ~                                                                                                                
 36|    ~                                               07                                                               
 37|    ~  FB 02                                     CF 07 07                                                            
 38|    ~     02                                                                                                         
   |    ~                                                                                                                
 40| 03 ~                                                                                                                
```
[その他の色塗り候補](./checksum0.txt)

----

## タイムいろいろ

|区間名|通過|区間|戦闘|備考|
|:---:|:---:|:---:|:---:|:---:|
|電源投入|00:00:00|||
|アニメティカ終了|00:02:01|00:02:01|||
|メモリーカード引き抜き|00:09:12|00:07:11|||
|エンディング終了|00:28:44|00:19:32|||

- 計測地点:
  - アニメティカ終了: アニメティカ起動中にリセットした瞬間

----

## 実際のプレイ

- アニメティカパートはそこそこ。
- 警備兵*2戦は敵が3回行動、エンカでは1回行動。
- セーブ時、「メモリーカードにんしきちゅうです。」のダイアログを1回出してしまった。

----

## おわりに

- 調査は楽しいのにプレイは虚無感がやばい。
- メイン進捗度`1999`はゲームのスクリプトを覗ける[Makou Reactor](https://github.com/myst6re/makoureactor/releases)なしではきっと気付けなかった。感謝。
- どうにかして任意コード実行で[FF7Credits](https://wiki.ffrtt.ru/index.php/FF7/Field/Script/Opcodes/49_MENU)を呼べれば短縮できるが。

----

## 参考

- [プレイステーション・ＰＡＤ／メモリ・インターフェースの解析](http://kaele.com/~kashima/games/ps_jpn.txt)
- [RPGツクール3を使ったPS1セーブデータの改ざん方法 | RTAPlay!](https://rta-play.info/tool/save-glitch/)
- [巡回冗長検査 - Wikipedia](https://ja.wikipedia.org/wiki/%E5%B7%A1%E5%9B%9E%E5%86%97%E9%95%B7%E6%A4%9C%E6%9F%BB)
- [resilar/crchack: Reversing CRC for fun and profit](https://github.com/resilar/crchack)
- [Black Chocobo](http://www.blackchocobo.com/)
- [Makou Reactor](https://github.com/myst6re/makoureactor/releases)
- [FF7 INT Notes v2.1.xlsx](https://www.dropbox.com/s/ia555udw67ywruc/FF7%20INT%20Notes%20v2.1.xlsx?dl=0)
