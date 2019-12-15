2年越しの公開(ごめんなさい)

<!-- TOC depthFrom:1 depthTo:2 -->

- [PS2DQ5カジノ検索モード for xyzzy](#ps2dq5カジノ検索モード-for-xyzzy)
  - [特徴](#特徴)
  - [導入](#導入)
  - [使い方](#使い方)
  - [参考文献](#参考文献)

<!-- /TOC -->

# PS2DQ5カジノ検索モード for xyzzy

[旧ページ](http://pingval.g1.xrea.com/ps2dq5/casino-mode/)

1. PS2DQ5のカジノの出目を手軽に検索して手軽に待ち時間を計算できるツールがほしい
2. でも1からじゃとても作れる気がしない・・・
3. なら既存のエディタを利用すればいいじゃん！

ということでxyzzylispで作成しました。当然xyzzy上でしか動作しません。

色付けのインクリメンタルサーチに[しょぼしょぼすくりぷと](https://edutainment-fun.com/script/xyzzy/index.html)さんの[isearch-deco.l](https://edutainment-fun.com/script/xyzzy/mode/isearch.html)を必要とします。

- [casino-mode v002](https://github.com/pingval/Speedrun/raw/master/DQ5/casino-mode/casino-mode002.zip)

## 特徴
- [一覧表示](./img/3-x1'.png)により、現在地以降全ての当たり目の待ち時間が俯瞰できる。
- [色付けインクリメンタルサーチ](./img/3-x3.png)によって出目を特定し易い。
- 待ち時間の計算に、現在の出目の回転(縦軸)だけでなくライン(横軸)も考慮。
- 多機能とはいえ元々ただのテキストエディタなので動作が軽い。
- [検索に連動して動作するタイマー](./img/3-x2'.png)を内蔵しているため、タイマーを別途用意する必要がない。

## 導入

**※既にxyzzyを利用されている方も、別の場所にカジノ専用のxyzzyを展開することを推奨します。通常使用との両立は困難と思われます。**

1. [xyzzy](http://xyzzy-022.github.io/)をインストールする。
2. casino-modeを導入する(site-lispフォルダとetcフォルダに上書き)。
3. [isearch-deco.l](https://edutainment-fun.com/script/xyzzy/mode/isearch.html)をsite-lispフォルダに入れる。
4. [xyzzy の音 - はじめに](http://hie.s64.xrea.com/xyzzy/note/first_step.html)などを参考にして環境変数XYZZYHOMEを設定する。xyzzy.exeと同じフォルダがいいでしょう。
5. 「casino-mode.xyzzy」を「.xyzzy」にリネームし、上でXYZZYHOMEに設定したフォルダに置く。既にxyzzyを使用されている方は適当に元の.xyzzyに追記してください。
6. xyzzyを起動する。フォントサイズの変更は「共通設定→フォント」から、MSゴシックの9か10辺りを推奨。カジノ検索専用ツールとしてxyzzyを使う分には、他に設定の変更が必要はところはないでしょう。

## 使い方
### キーバインド
| キー | 機能 |
| :---: | :--- |
| C-s(Ctrl+S) or s | インクリメンタルサーチ(順方向) |
| C-r or r | インクリメンタルサーチ(逆方向) |
| TAB	| 現在地を保持して100C表⇔10C表の切り替え |
| C-a or a | 現在地以降の当たり目一覧(※近すぎる当たり目は表示されない) |
| F3 | 現在地を基準にした待ち時間タイマー開始＆現在地以降の当たり目一覧を開く |
| M-g(Alt+G) | 回転数(とライン)を指定して移動 |

#### 待ち時間タイマー計測中
計測中でもF3を押せばまた待ち時間タイマーを開始する点に注意。

| キー | 機能 |
| :---: | :--- |
| 0 | タイマーに「ヘンリー奴隷の服外す(服)」補正(+0.3s)を加える/やめる |
| 1 | タイマーに「景品交換(景)」の補正(-0.2s)を加える/やめる |
| 2 | タイマーに「モンスター爺さん会話(爺)」の補正(+4.9s)を加える/やめる |
| 3 | タイマーに「3000回転待ち(3k)」の補正(+5.0s)を加える/やめる |
| F4 | タイマー停止 |

### 出目表の文字と絵柄の対応表
検索を素早く行えるよう、2～7の数字で置き換えている。

| 文字 | 絵柄 |
| :---: | :---: |
| 2 |	チェリー |
| 3	| プラム |
| 4	| ベル |
| 5	| スイカ |
| 6 | BAR |
| 7 | 7 |

### 実際の手順

画像が多くて重いので[別ページ](./usage.md)へ。

### 諸注意
- 起動時の現在地は10C表の-5回転のライン1となっている。これは、ロード後直接10Cスロットに入るのを想定しており、検索を容易にするため。
- 待ち時間の計算はカーソル位置を基準にしているため、スロットを出たときの現在地にカーソルを合わせておく必要がある。外したときはそのままでいいが、当たった場合は当たり目までカーソルを移動させるのを忘れないこと。
- インクリメンタルサーチ中、現在のカーソル位置で抜けるには`Enter`を押す。サーチ開始位置に戻るには`C-g`を押す。
- スロット出入り時の補正時間はデフォルトでは0.5sとしているが、これはプレイ環境に依存するところが大きいようなので、環境にそぐわないなら適切な時間に変更するとよい。.xyzzyに以下のように書く。
```
;; 標的の直前に入るための補正時間(秒)。早く入ってしまう場合は0.5より小さく、逆は大きく変更。
(setq *casino-normalize* 秒数)
```

## 参考文献
- [そうこの雑記帳　DQ5カジノスロット1000回転以降に関してまとめ(そうこさん)](http://souko2525.blog39.fc2.com/blog-entry-29.html)・[御茶麒麟](https://twitter.com/GiraffeTea)さん - 出目表(1～5000回転)
- [1コイン左から1番目／スロット完全攻略／ドラゴンクエスト５攻略(miyaさん)](http://miya.s16.xrea.com/dq/5/slot1-1.html) - 出目表(10コインスロット(一番左)の-11～0回転部分)
- [ドラクエ5[PS2]スロット出目表【検索用】ver.3.0(右弐さん)](http://uniright2.fc2web.com/archives.html) - 自分の出目表のフォーマットの原型というかなんといいますか
- [出目表抜粋 : 腹黒パンダさん日記(腹黒パンダさん)](https://harapan.exblog.jp/16828130/) - 出目表を2～7の数字で表すアイデア