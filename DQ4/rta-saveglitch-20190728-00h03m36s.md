﻿# [PS版DQ4 セーブデータ改竄RTA in 3:36](https://www.youtube.com/watch?v=tfuQmQ-ua6Y)

- プレイ日時: 2019年07月28日
- 計測区間: 本体の電源投入からTHE ENDの羽ペン消滅まで
- 使用ソフト:
  - RPGツクール3
  - PS版DQ4 アルティメットヒッツ版
- 使用本体: PS2(SCPH-90000)
- 使用コントローラ: Sony SCPH-10010
- 改ざん用のセーブデータ作成を計測区間に含める（事前に作成したセーブデータの利用は禁止！）
- アニメティカでの8ブロックセーブ中のメモリーカードの抜き差しは禁止（事前に作成したセーブデータを利用できる怖れがあるため）

----

## 戦略概要

- アニメティカで現在のマップをTHE END画面(MapID: 137)に改竄する。
- DQ4で「ぼうけんのしょをつくる」を選択し、セーブ途中でメモリーカードを引き抜く。そのデータをロードすると、神父のメッセージが流れた後にTHE ENDが表示される。
- エンジンはDQ7とほぼ同じだが、改造チェックが厳しい。それを突破するため[DQ7のとき](https://github.com/pingval/DQ7/blob/master/rta-saveglitch-20190630-00h02m49s.md)の3倍ほどの数のマスを塗る必要がある。
- メモリーカードの引き抜きタイミングは恐らくDQ7と同じ。

### セーブデータ詳細

以下のアドレスの中身は必須。これら以外は好きに変更して良い(はず)
```
0x4100..0x4101: 53 43 ;; "SC"
0x417f: 0x4100..0x417e のチェックサム(xor和)
0x4180: 06 or 07 ;; パーティの人数？
0x4181..0x4184: 00 00 00 00
0x4190..0x4193: d0 07 08 00 ;; DQ7と同じ値
0x41ae..0x41af 89 00 ;; The End画面のMapID(137)
0x41fc..0x41ff: 0x4180..0x41fb のチェックサム(CRC32/BZIP2)
0x4200: x & 0x10 != 0 && x & 0x40 != 0 && x & 0x20 == 0
0x427c..0x427f: 0x4200..0x427b のチェックサム(CRC32/BZIP2)
0x42ac: x & 0x80 != 0 && x & 0x40 == 0
0x42fc..0x42ff: 0x4280..0x42fb のチェックサム(CRC32/BZIP2)
```

- `0x4100..0x417f`の範囲のチェックサムの仕様は、後で確認するとDQ7でも同じだった。ただしDQ7は`0x4100..0x417f`を全て`00`で埋めても通る(任意の数の0のxor和は0なので)ので当時は気付かなかった。
- チェックサムのアルゴリズムはCRC32/BZIP2。[crchack](https://github.com/resilar/crchack)に渡すオプションは`-w32 -p04c11db7 -iffffffff -xffffffff`。
- `0x4000`に書き込まれると「こわれた　冒険の書」になるためメモリーカード引き抜き猶予時間はDQ7と同じで2f(たぶん)。

以下の色塗りを採用した。
```
AnimeMaker:
  DF: (  0, 28)
  07: ( 32, 27)
  A1: ( 38..39, 28)
  A1: ( 44, 28)
  A1: ( 46, 28)
  D0: ( 48, 27)
  07: ( 49, 27)
  08: ( 50, 27)
  D0: ( 53, 27)
  80: ( 65, 27)
  02: ( 66, 27)
  89: ( 78, 27)
  DF: (160, 27)
  A1: (198..199, 27)
  A1: (204, 27)
  A1: (206, 27)
  53: (224, 25)
  43: (225, 25)
  43: (226以上のどこか, 25)
  53: (226以上のどこか, 25)
Visual:
y\x|  0 ~  32                38 39             44    46    48 49 50       53                                  65 66                                  78 ~ 160 ~ 198199            204   206                                                   224225226227
---+--- ~ --------------------------------------------------------------------------------------------------------------------------------------------- ~ --- ~ ------------------------------------------------------------------------------------------
 25|    ~                                                                                                                                               ~     ~                                                                                53 43 43 53
   |    ~                                                                                                                                               ~     ~                                                                                           
 27|    ~  07                                              D0 07 08       D0                                  80 02                                  89 ~  DF ~  A1 A1             A1    A1                                                               
 28| DF ~                    A1 A1             A1    A1                                                                                                 ~     ~                                                                                           
```
- (0, 28)は左上の窓に隠れているので、L2ボタンで窓を全て消して塗っている。
- `0x53 ^ 0x43 ^ 0x10 = 0`なので`0x4102..0x417f`のうちどこかに`10`を塗ればチェックサムを0にできる。だがxor演算は両辺が同じ値だと0になり、かつ可換という性質があるので、どこかに`53`と`43`を塗ることによってもチェクサムは0になる。パレット変更をカットできるため後者の方が速い。
- 複数のパターンを探すのと覚えるのが面倒だったので、(160..287, 27)(`0x4200..0x427f`)と(0..127, 28)(`0x4280..0x42ff`)では同じ色塗りパターンを使っている。

y軸順: 
```
  53: (224, 25)
  43: (225, 25)
  43: (226以上のどこか, 25)
  53: (226以上のどこか, 25)
  07: ( 32, 27)
  D0: ( 48, 27)
  07: ( 49, 27)
  08: ( 50, 27)
  D0: ( 53, 27)
  80: ( 65, 27)
  02: ( 66, 27)
  89: ( 78, 27)
  DF: (160, 27)
  A1: (198..199, 27)
  A1: (204, 27)
  A1: (206, 27)
  DF: (  0, 28)
  A1: ( 38..39, 28)
  A1: ( 44, 28)
  A1: ( 46, 28)
```

その他の色塗り候補
- [`0x4180..0x41ff`](./0x4180_checksum.txt)
- ~~[`0x4200..0x427f`と`0x4280..0x42ff`共通](./0x4200_0x4280_checksum.txt)~~

----

## タイムいろいろ

|区間名|通過|区間|戦闘|備考|
|:---:|:---:|:---:|:---:|:---:|
|電源投入|00:00:00|||
|アニメティカ終了|00:02:41|00:02:41|||
|メモリーカード引き抜き|00:03:14|00:00:33|||
|エンディング終了|00:03:36|00:00:22|||

- 計測地点:
  - アニメティカ終了: アニメティカ起動中にリセットした瞬間

----

## 実際のプレイ

- アニメティカパートは色塗りを覚えきれておらずまだまだ遅い。
- DQ4パートは特にロスなし。

----

## おわりに

- [四字熟語最速記録の3:40](https://www.speedrun.com/Yojijukugo_Flash/run/zq3gx6ry)を切れたし色塗りマスの改善の余地もないではないので3:36で終えたが、アニメティカの操作がまだまだ遅いので、3:30切りはこのチャートのままでも充分可能だろう。
- 次はFF789。

----

## 参考

- [プレイステーション・ＰＡＤ／メモリ・インターフェースの解析](http://kaele.com/~kashima/games/ps_jpn.txt)
- [RPGツクール3を使ったPS1セーブデータの改ざん方法 | RTAPlay!](https://rta-play.info/tool/save-glitch/)
- [巡回冗長検査 - Wikipedia](https://ja.wikipedia.org/wiki/%E5%B7%A1%E5%9B%9E%E5%86%97%E9%95%B7%E6%A4%9C%E6%9F%BB)
- [resilar/crchack: Reversing CRC for fun and profit](https://github.com/resilar/crchack)
