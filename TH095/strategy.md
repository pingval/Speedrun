<!-- TOC depthFrom:1 depthTo:2 -->

- [東方文花帖 All Scenes RTA攻略](#東方文花帖-all-scenes-rta攻略)
  - [戦略概要](#戦略概要)
  - [シーン別攻略](#シーン別攻略)
  - [参考文献](#参考文献)

<!-- /TOC -->


----

# 東方文花帖 All Scenes RTA攻略

## 戦略概要

- 高速巻き即撮り
  - ファインダーカーソル(以下Fカーソル)初期位置付近の方向が撮影される。
  - 連続して高速巻き即撮りを行うと、2回目以降もそうなる(th95_udang1.rpy)
    - 低速ボタンと撮影ボタンを離してから撮っても、そうなることがある。
  - 途中で高速巻きを解除すると、その時点のFカーソル方向が適用される(th95_udang2.rpy)。
  - 通常の高速巻き即撮り(th95_udang3.rpy)。
- 最後の写真は、次の準備を考慮することなく、超望遠(9-6など)で撮って構わない。
- 画面左端で待機すると高速巻き中のチャージ量が見えないが、右端なら見えるため、右端で待機する。

----

### 巻き速度

- [東方文花帖 チャージ量の比較](https://docs.google.com/spreadsheets/d/1C11il558zGld9jc5ERySXFzNc34_Rk2060oSV9Wi9IU/edit#gid=1051693107)

のちの[ダブルスポイラー](https://wikiwiki.jp/let/etc/%E7%9F%A5%E8%AD%98/%E3%83%80%E3%83%96%E3%83%AB%E3%82%B9%E3%83%9D%E3%82%A4%E3%83%A9%E3%83%BC%E3%83%A1%E3%83%A2#o4773347)と同じ。巻きの継続時間をxフレームとして、

<dl>
  <dt>通常巻き</dt>
  <dd>
    <dl>
      <dt>x &lt; 60</dt>
      <dd>0.0625 + x/480 %/f</dd>
      <dt>60 &lt;= x</dt>
      <dd>0.1875 %/f</dd>
    </dl>
  </dd>
  <dt>高速巻き</dt>
  <dd>
    <dl>
      <dt>5 &lt;= x &lt; 70 (高速巻き時間5f未満は通常巻き状態として扱われる)</dt>
      <dd>0.125 + 3x/560 %/f</dd>
      <dt>70 &lt;= x</dt>
      <dd>0.5 %/f</dd>
    </dl>
  </dd>
</dl>

- 通常巻きも高速巻きも開始直後の巻き速度は遅い。最高速に乗るまでに、通常巻きは60f(1s)、高速巻きは70f(約1.17s)掛かる。
  - 開始直後の高速巻きは通常巻きの最高速よりも遅い。通常巻き最高速から高速巻きに切り替えた場合、チャージ量が追いつくまで20f掛かる。
  - 通常巻きと高速巻きを短時間で交互に切り替えるよりは、常に通常巻きとしたほうがチャージ速度は速い。4-6などでご注意を。
- 0%から100%まで溜まるのに掛かる時間は、通常巻きで554f(約9.23s)、高速巻きで228f(3.8s)。最高速同士の比較では高速巻きは通常巻きの約2.67倍。

### 撮影後のチャージ回復量

- 回復量の上限が増すというよりは、消した弾一発あたりの回復量が増すといったほうが正しい。
- ボスを撮った(=クリップされる)写真撮影後の回復量。ボスを撮れば撮るほど上限が上がる。
  - 空撮りの場合、上限は常に60%。これは、ボスを撮った写真でいうと12枚目にあたる。

| Boss Shot n枚目 | 回復量上限 | 空撮りとの比較 |
| :---: | :---: | :---: |
| 空撮り(参考) | 60% | - |
| 1 | 27% | 0.45 |
| 2 | 30% | 0.50 |
| 3 | 33% | 0.55 |
| 4 | 36% | 0.60 |
| 5 | 39% | 0.65 |
| 6 | 42% | 0.70 |
| 7 | 45% | 0.75 |
| 8 | 48% | 0.80 |
| 9 | 51% | 0.85 |

### 撮影後の自由時間

文の高速移動速度は5.0 dot/fなので、チャージを遅らせることなく移動できる距離は`5.0 * 60 = 300`。
感光でもそうなる？

### 難易度の目安

A: 一発打開率50%以下
B: 一発打開率75%以下
C: 気を抜けない
D: 気を抜かなければミスる要素なし
E: ミスる要素なし

A: 8-7, 9-6
B: 7-5, 9-4, 10-5, EX-7, EX-8

### Any%について

----

## シーン別攻略

|シーン|ボス|スペルカード名|撮影ノルマ|自分的難易度|リプレイ|
|:---:|:---:|:---:|:---:|:---:|:---:|
|1-1|リグル・ナイトバグ|[なし(リグル通常攻撃)](./strategy-01.md#1-1-なし(リグル通常攻撃))|3|E|[th95_ud1-1.rpy](./rpy/th95_ud1-1.rpy)|
|1-2|ルーミア|[なし(ルーミア通常攻撃)](./strategy-01.md#1-2-なし(ルーミア通常攻撃))|3|E|[th95_ud1-2.rpy](./rpy/th95_ud1-2.rpy)|
|1-3|リグル・ナイトバグ|[<ruby>蛍符<rp>(</rp><rt>ほたるふ</rt><rp>)</rp></ruby>「地上の恒星」](./strategy-01.md#1-3-蛍符「地上の恒星」)|5|D|[th95_ud1-3.rpy](./rpy/th95_ud1-3.rpy)|
|1-4|ルーミア|[<ruby>闇符<rp>(</rp><rt>やみふ</rt><rp>)</rp></ruby>「ダークサイドオブザムーン」](./strategy-01.md#1-4-闇符「ダークサイドオブザムーン」)|4|D|[th95_ud1-4.rpy](./rpy/th95_ud1-4.rpy)|
|1-5|リグル・ナイトバグ|[<ruby>蝶符<rp>(</rp><rt>ちょうふ</rt><rp>)</rp></ruby>「バタフライストーム」](./strategy-01.md#1-5-蝶符「バタフライストーム」)|5|D|[th95_ud1-5.rpy](./rpy/th95_ud1-5.rpy)|
|1-6|ルーミア|[<ruby>夜符<rp>(</rp><rt>よるふ</rt><rp>)</rp></ruby>「ミッドナイトバード」](./strategy-01.md#1-6-夜符「ミッドナイトバード」)|5|D|[th95_ud1-6.rpy](./rpy/th95_ud1-6.rpy)|
|2-1|チルノ|[なし(チルノ通常攻撃)](./strategy-02.md#2-1-なし(チルノ通常攻撃))|5|D|[th95_ud2-1.rpy](./rpy/th95_ud2-1.rpy)|
|2-2|レティ・ホワイトロック|[なし(レティ通常攻撃)](./strategy-02.md#2-2-なし(レティ通常攻撃))|4|D|[th95_ud2-2.rpy](./rpy/th95_ud2-2.rpy)|
|2-3|チルノ|[<ruby>雪符<rp>(</rp><rt>ゆきふ</rt><rp>)</rp></ruby>「ダイアモンドブリザード」](./strategy-02.md#2-3-雪符「ダイアモンドブリザード」)|5|D|[th95_ud2-3.rpy](./rpy/th95_ud2-3.rpy)|
|2-4|レティ・ホワイトロック|[<ruby>寒符<rp>(</rp><rt>かんふ</rt><rp>)</rp></ruby>「コールドスナップ」](./strategy-02.md#2-4-寒符「コールドスナップ」)|4|C|[th95_ud2-4.rpy](./rpy/th95_ud2-4.rpy)|
|2-5|チルノ|[<ruby>凍符<rp>(</rp><rt>とうふ</rt><rp>)</rp></ruby>「マイナス<ruby>K<rp>(</rp><rt>ケー</rt><rp>)</rp></ruby>」](./strategy-02.md#2-5-凍符「マイナスK」)|5|D|[th95_ud2-5.rpy](./rpy/th95_ud2-5.rpy)|
|2-6|レティ・ホワイトロック|[<ruby>冬符<rp>(</rp><rt>とうふ</rt><rp>)</rp></ruby>「ノーザンウイナー」](./strategy-02.md#2-6-冬符「ノーザンウイナー」)|5|D|[th95_ud2-6.rpy](./rpy/th95_ud2-6.rpy)|
|3-1|アリス・マーガトロイド|[なし(アリス通常攻撃)](./strategy-03.md#3-1-なし(アリス通常攻撃))|5|D|[th95_ud3-1.rpy](./rpy/th95_ud3-1.rpy)|
|3-2|<ruby>上白沢<rp>(</rp><rt>かみしらさわ</rt><rp>)</rp></ruby> <ruby>慧音<rp>(</rp><rt>けいね</rt><rp>)</rp></ruby>|[<ruby>光符<rp>(</rp><rt>こうふ</rt><rp>)</rp></ruby>「アマテラス」](./strategy-03.md#3-2-光符「アマテラス」)|5|D|[th95_ud3-2.rpy](./rpy/th95_ud3-2.rpy)|
|3-3|アリス・マーガトロイド|[<ruby>操符<rp>(</rp><rt>そうふ</rt><rp>)</rp></ruby>「ドールズインシー」](./strategy-03.md#3-3-操符「ドールズインシー」)|5|C|[th95_ud3-3.rpy](./rpy/th95_ud3-3.rpy)|
|3-4|<ruby>上白沢<rp>(</rp><rt>かみしらさわ</rt><rp>)</rp></ruby> <ruby>慧音<rp>(</rp><rt>けいね</rt><rp>)</rp></ruby>|[<ruby>包符<rp>(</rp><rt>ほうふ</rt><rp>)</rp></ruby>「昭和の雨」](./strategy-03.md#3-4-包符「昭和の雨」)|6|D|[th95_ud3-4.rpy](./rpy/th95_ud3-4.rpy)|
|3-5|アリス・マーガトロイド|[<ruby>呪符<rp>(</rp><rt>じゅふ</rt><rp>)</rp></ruby>「ストロードールカミカゼ」](./strategy-03.md#3-5-呪符「ストロードールカミカゼ」)|5|D|[th95_ud3-5.rpy](./rpy/th95_ud3-5.rpy)|
|3-6|<ruby>上白沢<rp>(</rp><rt>かみしらさわ</rt><rp>)</rp></ruby> <ruby>慧音<rp>(</rp><rt>けいね</rt><rp>)</rp></ruby>|[<ruby>葵符<rp>(</rp><rt>ぎふ</rt><rp>)</rp></ruby>「<ruby>水戸<rp>(</rp><rt>みと</rt><rp>)</rp></ruby>の<ruby>光圀<rp>(</rp><rt>みつくに</rt><rp>)</rp></ruby>」](./strategy-03.md#3-6-葵符「水戸の光圀」)|7|D|[th95_ud3-6.rpy](./rpy/th95_ud3-6.rpy)|
|3-7|アリス・マーガトロイド|[<ruby>赤符<rp>(</rp><rt>せきふ</rt><rp>)</rp></ruby>「ドールミラセティ」](./strategy-03.md#3-7-赤符「ドールミラセティ」)|5|C|[th95_ud3-7.rpy](./rpy/th95_ud3-7.rpy)|
|3-8|<ruby>上白沢<rp>(</rp><rt>かみしらさわ</rt><rp>)</rp></ruby> <ruby>慧音<rp>(</rp><rt>けいね</rt><rp>)</rp></ruby>|[<ruby>倭符<rp>(</rp><rt>わふ</rt><rp>)</rp></ruby>「<ruby>邪馬台の国<rp>(</rp><rt>やまたいのくに</rt><rp>)</rp></ruby>」](./strategy-03.md#3-8-倭符「邪馬台の国」)|4|D|[th95_ud3-8.rpy](./rpy/th95_ud3-8.rpy)|
|4-1|<ruby>鈴仙<rp>(</rp><rt>れいせん</rt><rp>)</rp></ruby>・<ruby>優曇華院<rp>(</rp><rt>うどんげいん</rt><rp>)</rp></ruby>・イナバ|[なし(<ruby>鈴仙<rp>(</rp><rt>れいせん</rt><rp>)</rp></ruby>通常攻撃)](./strategy-04.md#4-1-なし(鈴仙通常攻撃))|4|C|[th95_ud4-1.rpy](./rpy/th95_ud4-1.rpy)|
|4-2|メディスン・メランコリー|[<ruby>霧符<rp>(</rp><rt>むふ</rt><rp>)</rp></ruby>「ガシングガーデン」](./strategy-04.md#4-2-霧符「ガシングガーデン」)|6|C|[th95_ud4-2.rpy](./rpy/th95_ud4-2.rpy)|
|4-3|<ruby>因幡<rp>(</rp><rt>いなば</rt><rp>)</rp></ruby> <ruby>てゐ<rp>(</rp><rt>てい</rt><rp>)</rp></ruby>|[<ruby>脱兎<rp>(</rp><rt>だっと</rt><rp>)</rp></ruby>「フラスターエスケープ」](./strategy-04.md#4-3-脱兎「フラスターエスケープ」)|5|C|[th95_ud4-3.rpy](./rpy/th95_ud4-3.rpy)|
|4-4|<ruby>鈴仙<rp>(</rp><rt>れいせん</rt><rp>)</rp></ruby>・<ruby>優曇華院<rp>(</rp><rt>うどんげいん</rt><rp>)</rp></ruby>・イナバ|[<ruby>散符<rp>(</rp><rt>さんふ</rt><rp>)</rp></ruby>「<ruby>朧月花栞<rp>(</rp><rt>ろうげつかかん</rt><rp>)</rp></ruby>（ロケット・イン・ミスト）」](./strategy-04.md#4-4-散符「朧月花栞（ロケット・イン・ミスト）」)|6|C|[th95_ud4-4.rpy](./rpy/th95_ud4-4.rpy)|
|4-5|メディスン・メランコリー|[<ruby>毒符<rp>(</rp><rt>どくふ</rt><rp>)</rp></ruby>「ポイズンブレス」](./strategy-04.md#4-5-毒符「ポイズンブレス」)|5|D|[th95_ud4-5.rpy](./rpy/th95_ud4-5.rpy)|
|4-6|<ruby>鈴仙<rp>(</rp><rt>れいせん</rt><rp>)</rp></ruby>・<ruby>優曇華院<rp>(</rp><rt>うどんげいん</rt><rp>)</rp></ruby>・イナバ|[<ruby>波符<rp>(</rp><rt>はふ</rt><rp>)</rp></ruby>「幻の月（インビジブルハーフムーン）」](./strategy-04.md#4-6-波符「幻の月（インビジブルハーフムーン）」)|6|C|[th95_ud4-6.rpy](./rpy/th95_ud4-6.rpy)|
|4-7|メディスン・メランコリー|[<ruby>譫妄<rp>(</rp><rt>せんもう</rt><rp>)</rp></ruby>「イントゥデリリウム」](./strategy-04.md#4-7-譫妄「イントゥデリリウム」)|6|C|[th95_ud4-7.rpy](./rpy/th95_ud4-7.rpy)|
|4-8|<ruby>因幡<rp>(</rp><rt>いなば</rt><rp>)</rp></ruby> <ruby>てゐ<rp>(</rp><rt>てい</rt><rp>)</rp></ruby>|[<ruby>借符<rp>(</rp><rt>しゃくふ</rt><rp>)</rp></ruby>「<ruby>大穴牟遅様<rp>(</rp><rt>おおなむちさま</rt><rp>)</rp></ruby>の薬」](./strategy-04.md#4-8-借符「大穴牟遅様の薬」)|6|C|[th95_ud4-8.rpy](./rpy/th95_ud4-8.rpy)|
|4-9|<ruby>鈴仙<rp>(</rp><rt>れいせん</rt><rp>)</rp></ruby>・<ruby>優曇華院<rp>(</rp><rt>うどんげいん</rt><rp>)</rp></ruby>・イナバ|[<ruby>狂夢<rp>(</rp><rt>きょうむ</rt><rp>)</rp></ruby>「<ruby>風狂<rp>(</rp><rt>ふうきょう</rt><rp>)</rp></ruby>の夢（ドリームワールド）」](./strategy-04.md#4-9-狂夢「風狂の夢（ドリームワールド）」)|5|D|[th95_ud4-9.rpy](./rpy/th95_ud4-9.rpy)|
|5-1|<ruby>紅<rp>(</rp><rt>ホン</rt><rp>)</rp></ruby> <ruby>美鈴<rp>(</rp><rt>メイリン</rt><rp>)</rp></ruby>|[なし(<ruby>美鈴<rp>(</rp><rt>メイリン</rt><rp>)</rp></ruby>通常攻撃)](./strategy-05.md#5-1-なし(美鈴通常攻撃))|5|D|[th95_ud5-1.rpy](./rpy/th95_ud5-1.rpy)|
|5-2|パチュリー・ノーレッジ|[<ruby>日＆水符<rp>(</rp><rt>にち＆すいふ</rt><rp>)</rp></ruby>「ハイドロジェナスプロミネンス」](./strategy-05.md#5-2-日＆水符「ハイドロジェナスプロミネンス」)|5|D|[th95_ud5-2.rpy](./rpy/th95_ud5-2.rpy)|
|5-3|<ruby>紅<rp>(</rp><rt>ホン</rt><rp>)</rp></ruby> <ruby>美鈴<rp>(</rp><rt>メイリン</rt><rp>)</rp></ruby>|[<ruby>華符<rp>(</rp><rt>かふ</rt><rp>)</rp></ruby>「<ruby>彩光蓮華掌<rp>(</rp><rt>さいこうれんげしょう</rt><rp>)</rp></ruby>」](./strategy-05.md#5-3-華符「彩光蓮華掌」)|5|D|[th95_ud5-3.rpy](./rpy/th95_ud5-3.rpy)|
|5-4|パチュリー・ノーレッジ|[<ruby>水＆火符<rp>(</rp><rt>すい＆かふ</rt><rp>)</rp></ruby>「フロギスティックレイン」](./strategy-05.md#5-4-水＆火符「フロギスティックレイン」)|5|C|[th95_ud5-4.rpy](./rpy/th95_ud5-4.rpy)|
|5-5|<ruby>紅<rp>(</rp><rt>ホン</rt><rp>)</rp></ruby> <ruby>美鈴<rp>(</rp><rt>メイリン</rt><rp>)</rp></ruby>|[<ruby>彩翔<rp>(</rp><rt>さいしょう</rt><rp>)</rp></ruby>「<ruby>飛花落葉<rp>(</rp><rt>ひからくよう</rt><rp>)</rp></ruby>」](./strategy-05.md#5-5-彩翔「飛花落葉」)|6|C|[th95_ud5-5.rpy](./rpy/th95_ud5-5.rpy)|
|5-6|パチュリー・ノーレッジ|[<ruby>月＆木符<rp>(</rp><rt>げつ＆もくふ</rt><rp>)</rp></ruby>「サテライトヒマワリ」](./strategy-05.md#5-6-月＆木符「サテライトヒマワリ」)|5|E|[th95_ud5-6.rpy](./rpy/th95_ud5-6.rpy)|
|5-7|<ruby>紅<rp>(</rp><rt>ホン</rt><rp>)</rp></ruby> <ruby>美鈴<rp>(</rp><rt>メイリン</rt><rp>)</rp></ruby>|[<ruby>彩華<rp>(</rp><rt>さいか</rt><rp>)</rp></ruby>「<ruby>虹色太極拳<rp>(</rp><rt>こうしょくたいきょくけん</rt><rp>)</rp></ruby>」](./strategy-05.md#5-7-彩華「虹色太極拳」)|7|D|[th95_ud5-7.rpy](./rpy/th95_ud5-7.rpy)|
|5-8|パチュリー・ノーレッジ|[<ruby>日＆月符<rp>(</rp><rt>にち＆げつふ</rt><rp>)</rp></ruby>「ロイヤルダイアモンドリング」](./strategy-05.md#5-8-日＆月符「ロイヤルダイアモンドリング」)|6|D|[th95_ud5-8.rpy](./rpy/th95_ud5-8.rpy)|
|6-1|<ruby>橙<rp>(</rp><rt>ちぇん</rt><rp>)</rp></ruby>|[なし(<ruby>橙<rp>(</rp><rt>ちぇん</rt><rp>)</rp></ruby>通常攻撃)](./strategy-06.md#6-1-なし(橙通常攻撃))|8|D|[th95_ud6-1.rpy](./rpy/th95_ud6-1.rpy)|
|6-2|<ruby>魂魄<rp>(</rp><rt>こんぱく</rt><rp>)</rp></ruby> <ruby>妖夢<rp>(</rp><rt>ようむ</rt><rp>)</rp></ruby>|[<ruby>人智剣<rp>(</rp><rt>じんちけん</rt><rp>)</rp></ruby>「天女返し」](./strategy-06.md#6-2-人智剣「天女返し」)|4|C|[th95_ud6-2.rpy](./rpy/th95_ud6-2.rpy)|
|6-3|<ruby>橙<rp>(</rp><rt>ちぇん</rt><rp>)</rp></ruby>|[<ruby>星符<rp>(</rp><rt>せいふ</rt><rp>)</rp></ruby>「飛び重ね鱗」](./strategy-06.md#6-3-星符「飛び重ね鱗」)|5|C|[th95_ud6-3.rpy](./rpy/th95_ud6-3.rpy)|
|6-4|<ruby>魂魄<rp>(</rp><rt>こんぱく</rt><rp>)</rp></ruby> <ruby>妖夢<rp>(</rp><rt>ようむ</rt><rp>)</rp></ruby>|[<ruby>妄執剣<rp>(</rp><rt>もうしゅうけん</rt><rp>)</rp></ruby>「修羅の血」](./strategy-06.md#6-4-妄執剣「修羅の血」)|3|C|[th95_ud6-4.rpy](./rpy/th95_ud6-4.rpy)|
|6-5|<ruby>橙<rp>(</rp><rt>ちぇん</rt><rp>)</rp></ruby>|[<ruby>鬼神<rp>(</rp><rt>きしん</rt><rp>)</rp></ruby>「<ruby>鳴動持国天<rp>(</rp><rt>めいどうじこくてん</rt><rp>)</rp></ruby>」](./strategy-06.md#6-5-鬼神「鳴動持国天」)|7|D|[th95_ud6-5.rpy](./rpy/th95_ud6-5.rpy)|
|6-6|<ruby>魂魄<rp>(</rp><rt>こんぱく</rt><rp>)</rp></ruby> <ruby>妖夢<rp>(</rp><rt>ようむ</rt><rp>)</rp></ruby>|[<ruby>天星剣<rp>(</rp><rt>てんせいけん</rt><rp>)</rp></ruby>「<ruby>涅槃寂静<rp>(</rp><rt>ねはんじゃくじょう</rt><rp>)</rp></ruby>の如し」](./strategy-06.md#6-6-天星剣「涅槃寂静の如し」)|5|C|[th95_ud6-6.rpy](./rpy/th95_ud6-6.rpy)|
|6-7|<ruby>橙<rp>(</rp><rt>ちぇん</rt><rp>)</rp></ruby>|[化猫「<ruby>橙<rp>(</rp><rt>ちぇん</rt><rp>)</rp></ruby>」](./strategy-06.md#6-7-化猫「橙」)|5|D|[th95_ud6-7.rpy](./rpy/th95_ud6-7.rpy)|
|6-8|<ruby>魂魄<rp>(</rp><rt>こんぱく</rt><rp>)</rp></ruby> <ruby>妖夢<rp>(</rp><rt>ようむ</rt><rp>)</rp></ruby>|[<ruby>四生剣<rp>(</rp><rt>しせいけん</rt><rp>)</rp></ruby>「<ruby>衆生無情<rp>(</rp><rt>しゅじょうむじょう</rt><rp>)</rp></ruby>の響き」](./strategy-06.md#6-8-四生剣「衆生無情の響き」)|5|C|[th95_ud6-8.rpy](./rpy/th95_ud6-8.rpy)|
|7-1|<ruby>十六夜<rp>(</rp><rt>いざよい</rt><rp>)</rp></ruby> <ruby>咲夜<rp>(</rp><rt>さくや</rt><rp>)</rp></ruby>|[なし(<ruby>咲夜<rp>(</rp><rt>さくや</rt><rp>)</rp></ruby>通常攻撃)](./strategy-07.md#7-1-なし(咲夜通常攻撃))|9|D|[th95_ud7-1.rpy](./rpy/th95_ud7-1.rpy)|
|7-2|レミリア・スカーレット|[<ruby>魔符<rp>(</rp><rt>まふ</rt><rp>)</rp></ruby>「全世界ナイトメア」](./strategy-07.md#7-2-魔符「全世界ナイトメア」)|3|C|[th95_ud7-2.rpy](./rpy/th95_ud7-2.rpy)|
|7-3|<ruby>十六夜<rp>(</rp><rt>いざよい</rt><rp>)</rp></ruby> <ruby>咲夜<rp>(</rp><rt>さくや</rt><rp>)</rp></ruby>|[<ruby>時符<rp>(</rp><rt>じふ</rt><rp>)</rp></ruby>「トンネルエフェクト」](./strategy-07.md#7-3-時符「トンネルエフェクト」)|5|C|[th95_ud7-3.rpy](./rpy/th95_ud7-3.rpy)|
|7-4|レミリア・スカーレット|[<ruby>紅符<rp>(</rp><rt>こうふ</rt><rp>)</rp></ruby>「ブラッディマジックスクウェア」](./strategy-07.md#7-4-紅符「ブラッディマジックスクウェア」)|7|D|[th95_ud7-4.rpy](./rpy/th95_ud7-4.rpy)|
|7-5|<ruby>十六夜<rp>(</rp><rt>いざよい</rt><rp>)</rp></ruby> <ruby>咲夜<rp>(</rp><rt>さくや</rt><rp>)</rp></ruby>|[<ruby>空<rp>(</rp><rt>くう</rt><rp>)</rp></ruby>虚「インフレーションスクウェア」](./strategy-07.md#7-5-空虚「インフレーションスクウェア」)|6|B|[th95_ud7-5.rpy](./rpy/th95_ud7-5.rpy)|
|7-6|レミリア・スカーレット|[<ruby>紅蝙蝠<rp>(</rp><rt>あかこうもり</rt><rp>)</rp></ruby>「ヴァンピリッシュナイト」](./strategy-07.md#7-6-紅蝙蝠「ヴァンピリッシュナイト」)|7|C|[th95_ud7-6.rpy](./rpy/th95_ud7-6.rpy)|
|7-7|<ruby>十六夜<rp>(</rp><rt>いざよい</rt><rp>)</rp></ruby> <ruby>咲夜<rp>(</rp><rt>さくや</rt><rp>)</rp></ruby>|[<ruby>銀符<rp>(</rp><rt>ぎんふ</rt><rp>)</rp></ruby>「パーフェクトメイド」](./strategy-07.md#7-7-銀符「パーフェクトメイド」)|5|D|[th95_ud7-7.rpy](./rpy/th95_ud7-7.rpy)|
|7-8|レミリア・スカーレット|[<ruby>神鬼<rp>(</rp><rt>しんき</rt><rp>)</rp></ruby>「レミリアストーカー」](./strategy-07.md#7-8-神鬼「レミリアストーカー」)|7|C|[th95_ud7-8.rpy](./rpy/th95_ud7-8.rpy)|
|8-1|<ruby>八雲<rp>(</rp><rt>やくも</rt><rp>)</rp></ruby> <ruby>藍<rp>(</rp><rt>らん</rt><rp>)</rp></ruby>|[なし(<ruby>藍<rp>(</rp><rt>らん</rt><rp>)</rp></ruby>通常攻撃)](./strategy-08.md#8-1-なし(藍通常攻撃))|6|D|[th95_ud8-1.rpy](./rpy/th95_ud8-1.rpy)|
|8-2|<ruby>西行寺<rp>(</rp><rt>さいぎょうじ</rt><rp>)</rp></ruby> <ruby>幽々子<rp>(</rp><rt>ゆゆこ</rt><rp>)</rp></ruby>|[<ruby>幽雅<rp>(</rp><rt>ゆうが</rt><rp>)</rp></ruby>「<ruby>死出<rp>(</rp><rt>しで</rt><rp>)</rp></ruby>の<ruby>誘蛾灯<rp>(</rp><rt>ゆうがとう</rt><rp>)</rp></ruby>」](./strategy-08.md#8-2-幽雅「死出の誘蛾灯」)|7|D|[th95_ud8-2.rpy](./rpy/th95_ud8-2.rpy)|
|8-3|<ruby>八雲<rp>(</rp><rt>やくも</rt><rp>)</rp></ruby> <ruby>藍<rp>(</rp><rt>らん</rt><rp>)</rp></ruby>|[<ruby>密符<rp>(</rp><rt>みつふ</rt><rp>)</rp></ruby>「<ruby>御大師様<rp>(</rp><rt>おだいしさま</rt><rp>)</rp></ruby>の<ruby>秘鍵<rp>(</rp><rt>ひけん</rt><rp>)</rp></ruby>」](./strategy-08.md#8-3-密符「御大師様の秘鍵」)|6|C|[th95_ud8-3.rpy](./rpy/th95_ud8-3.rpy)|
|8-4|<ruby>西行寺<rp>(</rp><rt>さいぎょうじ</rt><rp>)</rp></ruby> <ruby>幽々子<rp>(</rp><rt>ゆゆこ</rt><rp>)</rp></ruby>|[<ruby>蝶符<rp>(</rp><rt>ちょうふ</rt><rp>)</rp></ruby>「<ruby>鳳蝶紋<rp>(</rp><rt>あげはもん</rt><rp>)</rp></ruby>の<ruby>死槍<rp>(</rp><rt>しそう</rt><rp>)</rp></ruby>」](./strategy-08.md#8-4-蝶符「鳳蝶紋の死槍」)|7|C|[th95_ud8-4.rpy](./rpy/th95_ud8-4.rpy)|
|8-5|<ruby>八雲<rp>(</rp><rt>やくも</rt><rp>)</rp></ruby> <ruby>藍<rp>(</rp><rt>らん</rt><rp>)</rp></ruby>|[<ruby>行符<rp>(</rp><rt>ぎょうふ</rt><rp>)</rp></ruby>「<ruby>八千万枚護摩<rp>(</rp><rt>はっせんまんまいごま</rt><rp>)</rp></ruby>」](./strategy-08.md#8-5-行符「八千万枚護摩」)|7|C|[th95_ud8-5.rpy](./rpy/th95_ud8-5.rpy)|
|8-6|<ruby>西行寺<rp>(</rp><rt>さいぎょうじ</rt><rp>)</rp></ruby> <ruby>幽々子<rp>(</rp><rt>ゆゆこ</rt><rp>)</rp></ruby>|[<ruby>死符<rp>(</rp><rt>しふ</rt><rp>)</rp></ruby>「酔人の生、死の夢幻」](./strategy-08.md#8-6-死符「酔人の生、死の夢幻」)|10|C|[th95_ud8-6.rpy](./rpy/th95_ud8-6.rpy)|
|8-7|<ruby>八雲<rp>(</rp><rt>やくも</rt><rp>)</rp></ruby> <ruby>藍<rp>(</rp><rt>らん</rt><rp>)</rp></ruby>|[超人「<ruby>飛翔役小角<rp>(</rp><rt>ひしょうえんのおづの</rt><rp>)</rp></ruby>」](./strategy-08.md#8-7-超人「飛翔役小角」)|8|A|[th95_ud8-7.rpy](./rpy/th95_ud8-7.rpy)|
|8-8|<ruby>西行寺<rp>(</rp><rt>さいぎょうじ</rt><rp>)</rp></ruby> <ruby>幽々子<rp>(</rp><rt>ゆゆこ</rt><rp>)</rp></ruby>|[「<ruby>死蝶浮月<rp>(</rp><rt>しちょうふげつ</rt><rp>)</rp></ruby>」](./strategy-08.md#8-8-「死蝶浮月」)|4|D|[th95_ud8-8.rpy](./rpy/th95_ud8-8.rpy)|
|9-1|<ruby>八意<rp>(</rp><rt>やごころ</rt><rp>)</rp></ruby> <ruby>永琳<rp>(</rp><rt>えいりん</rt><rp>)</rp></ruby>|[なし(<ruby>永琳<rp>(</rp><rt>えいりん</rt><rp>)</rp></ruby>通常攻撃)](./strategy-09.md#9-1-なし(永琳通常攻撃))|6|C|[th95_ud9-1.rpy](./rpy/th95_ud9-1.rpy)|
|9-2|<ruby>蓬莱<rp>(</rp><rt>ほうらい</rt><rp>)</rp></ruby>山 <ruby>輝夜<rp>(</rp><rt>かぐや</rt><rp>)</rp></ruby>|[新難題「月のイルメナイト」](./strategy-09.md#9-2-新難題「月のイルメナイト」)|6|C|[th95_ud9-2.rpy](./rpy/th95_ud9-2.rpy)|
|9-3|<ruby>八意<rp>(</rp><rt>やごころ</rt><rp>)</rp></ruby> <ruby>永琳<rp>(</rp><rt>えいりん</rt><rp>)</rp></ruby>|[<ruby>薬符<rp>(</rp><rt>やくふ</rt><rp>)</rp></ruby>「<ruby>胡蝶夢丸<rp>(</rp><rt>こちょうむがん</rt><rp>)</rp></ruby>ナイトメア」](./strategy-09.md#9-3-薬符「胡蝶夢丸ナイトメア」)|7|C|[th95_ud9-3.rpy](./rpy/th95_ud9-3.rpy)|
|9-4|<ruby>蓬莱<rp>(</rp><rt>ほうらい</rt><rp>)</rp></ruby>山 <ruby>輝夜<rp>(</rp><rt>かぐや</rt><rp>)</rp></ruby>|[新難題「エイジャの<ruby>赤石<rp>(</rp><rt>せきせき</rt><rp>)</rp></ruby>」](./strategy-09.md#9-4-新難題「エイジャの赤石」)|6|B|[th95_ud9-4.rpy](./rpy/th95_ud9-4.rpy)|
|9-5|<ruby>八意<rp>(</rp><rt>やごころ</rt><rp>)</rp></ruby> <ruby>永琳<rp>(</rp><rt>えいりん</rt><rp>)</rp></ruby>|[<ruby>錬丹<rp>(</rp><rt>れんたん</rt><rp>)</rp></ruby>「水銀の海」](./strategy-09.md#9-5-錬丹「水銀の海」)|6|D|[th95_ud9-5.rpy](./rpy/th95_ud9-5.rpy)|
|9-6|<ruby>蓬莱<rp>(</rp><rt>ほうらい</rt><rp>)</rp></ruby>山 <ruby>輝夜<rp>(</rp><rt>かぐや</rt><rp>)</rp></ruby>|[新難題「金閣寺の一枚天井」](./strategy-09.md#9-6-新難題「金閣寺の一枚天井」)|7|A|[th95_ud9-6.rpy](./rpy/th95_ud9-6.rpy)|
|9-7|<ruby>八意<rp>(</rp><rt>やごころ</rt><rp>)</rp></ruby> <ruby>永琳<rp>(</rp><rt>えいりん</rt><rp>)</rp></ruby>|[秘薬「<ruby>仙香玉兎<rp>(</rp><rt>せんこうぎょくと</rt><rp>)</rp></ruby>」](./strategy-09.md#9-7-秘薬「仙香玉兎」)|8|C|[th95_ud9-7.rpy](./rpy/th95_ud9-7.rpy)|
|9-8|<ruby>蓬莱<rp>(</rp><rt>ほうらい</rt><rp>)</rp></ruby>山 <ruby>輝夜<rp>(</rp><rt>かぐや</rt><rp>)</rp></ruby>|[新難題「ミステリウム」](./strategy-09.md#9-8-新難題「ミステリウム」)|7|D|[th95_ud9-8.rpy](./rpy/th95_ud9-8.rpy)|
|10-1|<ruby>小野塚<rp>(</rp><rt>おのづか</rt><rp>)</rp></ruby> <ruby>小町<rp>(</rp><rt>こまち</rt><rp>)</rp></ruby>|[なし(<ruby>小町<rp>(</rp><rt>こまち</rt><rp>)</rp></ruby>通常攻撃)](./strategy-10.md#10-1-なし(小町通常攻撃))|8|C|[th95_uda-1.rpy](./rpy/th95_uda-1.rpy)|
|10-2|<ruby>四季映姫<rp>(</rp><rt>しきえいき</rt><rp>)</rp></ruby>・ヤマザナドゥ|[<ruby>嘘言<rp>(</rp><rt>きょげん</rt><rp>)</rp></ruby>「タン・オブ・ウルフ」](./strategy-10.md#10-2-嘘言「タン・オブ・ウルフ」)|6|C|[th95_uda-2.rpy](./rpy/th95_uda-2.rpy)|
|10-3|<ruby>小野塚<rp>(</rp><rt>おのづか</rt><rp>)</rp></ruby> <ruby>小町<rp>(</rp><rt>こまち</rt><rp>)</rp></ruby>|[<ruby>死歌<rp>(</rp><rt>しか</rt><rp>)</rp></ruby>「<ruby>八重霧<rp>(</rp><rt>やえぎり</rt><rp>)</rp></ruby>の渡し」](./strategy-10.md#10-3-死歌「八重霧の渡し」)|6|B|[th95_uda-3.rpy](./rpy/th95_uda-3.rpy)|
|10-4|<ruby>四季映姫<rp>(</rp><rt>しきえいき</rt><rp>)</rp></ruby>・ヤマザナドゥ|[審判「<ruby>十王裁判<rp>(</rp><rt>じゅうおうさいばん</rt><rp>)</rp></ruby>」](./strategy-10.md#10-4-審判「十王裁判」)|10|C|[th95_uda-4.rpy](./rpy/th95_uda-4.rpy)|
|10-5|<ruby>小野塚<rp>(</rp><rt>おのづか</rt><rp>)</rp></ruby> <ruby>小町<rp>(</rp><rt>こまち</rt><rp>)</rp></ruby>|[<ruby>古雨<rp>(</rp><rt>こう</rt><rp>)</rp></ruby>「<ruby>黄泉中有<rp>(</rp><rt>よみちゅうう</rt><rp>)</rp></ruby>の旅の雨」](./strategy-10.md#10-5-古雨「黄泉中有の旅の雨」)|7|B|[th95_uda-5.rpy](./rpy/th95_uda-5.rpy)|
|10-6|<ruby>四季映姫<rp>(</rp><rt>しきえいき</rt><rp>)</rp></ruby>・ヤマザナドゥ|[審判「ギルティ・オワ・ノットギルティ」](./strategy-10.md#10-6-審判「ギルティ・オワ・ノットギルティ」)|6|C|[th95_uda-6.rpy](./rpy/th95_uda-6.rpy)|
|10-7|<ruby>小野塚<rp>(</rp><rt>おのづか</rt><rp>)</rp></ruby> <ruby>小町<rp>(</rp><rt>こまち</rt><rp>)</rp></ruby>|[<ruby>死価<rp>(</rp><rt>しか</rt><rp>)</rp></ruby>「プライス・オブ・ライフ」](./strategy-10.md#10-7-死価「プライス・オブ・ライフ」)|6|C|[th95_uda-7.rpy](./rpy/th95_uda-7.rpy)|
|10-8|<ruby>四季映姫<rp>(</rp><rt>しきえいき</rt><rp>)</rp></ruby>・ヤマザナドゥ|[審判「<ruby>浄頗梨審判<rp>(</rp><rt>じょうはりしんぱん</rt><rp>)</rp></ruby>　‐<ruby>射命丸<rp>(</rp><rt>しゃめいまる</rt><rp>)</rp></ruby><ruby>文<rp>(</rp><rt>あや</rt><rp>)</rp></ruby>‐」](./strategy-10.md#10-8-審判「浄頗梨審判　‐射命丸文‐」)|9|C|[th95_uda-8.rpy](./rpy/th95_uda-8.rpy)|
|EX-1|フランドール・スカーレット|[<ruby>禁忌<rp>(</rp><rt>きんき</rt><rp>)</rp></ruby>「フォービドゥンフルーツ」](./strategy-EX.md#EX-1-禁忌「フォービドゥンフルーツ」)|6|C|[th95_udx-1.rpy](./rpy/th95_udx-1.rpy)|
|EX-2|フランドール・スカーレット|[<ruby>禁忌<rp>(</rp><rt>きんき</rt><rp>)</rp></ruby>「禁じられた遊び」](./strategy-EX.md#EX-2-禁忌「禁じられた遊び」)|6|C|[th95_udx-2.rpy](./rpy/th95_udx-2.rpy)|
|EX-3|<ruby>八雲<rp>(</rp><rt>やくも</rt><rp>)</rp></ruby> <ruby>紫<rp>(</rp><rt>ゆかり</rt><rp>)</rp></ruby>|[<ruby>境符<rp>(</rp><rt>きょうふ</rt><rp>)</rp></ruby>「<ruby>色<rp>(</rp><rt>しき</rt><rp>)</rp></ruby>と<ruby>空<rp>(</rp><rt>くう</rt><rp>)</rp></ruby>の境界」](./strategy-EX.md#EX-3-境符「色と空の境界」)|5|C|[th95_udx-3.rpy](./rpy/th95_udx-3.rpy)|
|EX-4|<ruby>八雲<rp>(</rp><rt>やくも</rt><rp>)</rp></ruby> <ruby>紫<rp>(</rp><rt>ゆかり</rt><rp>)</rp></ruby>|[<ruby>境符<rp>(</rp><rt>きょうふ</rt><rp>)</rp></ruby>「波と粒の境界」](./strategy-EX.md#EX-4-境符「波と粒の境界」)|6|C|[th95_udx-4.rpy](./rpy/th95_udx-4.rpy)|
|EX-5|<ruby>藤原<rp>(</rp><rt>ふじわらの</rt><rp>)</rp></ruby> <ruby>妹紅<rp>(</rp><rt>もこう</rt><rp>)</rp></ruby>|[<ruby>貴人<rp>(</rp><rt>きじん</rt><rp>)</rp></ruby>「サンジェルマンの忠告」](./strategy-EX.md#EX-5-貴人「サンジェルマンの忠告」)|10|C|[th95_udx-5.rpy](./rpy/th95_udx-5.rpy)|
|EX-6|<ruby>藤原<rp>(</rp><rt>ふじわらの</rt><rp>)</rp></ruby> <ruby>妹紅<rp>(</rp><rt>もこう</rt><rp>)</rp></ruby>|[<ruby>蓬莱<rp>(</rp><rt>ほうらい</rt><rp>)</rp></ruby>「<ruby>瑞江浦嶋子<rp>(</rp><rt>みずのえうらしまのこ</rt><rp>)</rp></ruby>と<ruby>五色<rp>(</rp><rt>ごしき</rt><rp>)</rp></ruby>の<ruby>瑞亀<rp>(</rp><rt>ずいき</rt><rp>)</rp></ruby>」](./strategy-EX.md#EX-6-蓬莱「瑞江浦嶋子と五色の瑞亀」)|5|D|[th95_udx-6.rpy](./rpy/th95_udx-6.rpy)|
|EX-7|<ruby>伊吹<rp>(</rp><rt>いぶき</rt><rp>)</rp></ruby> <ruby>萃香<rp>(</rp><rt>すいか</rt><rp>)</rp></ruby>|[<ruby>鬼気<rp>(</rp><rt>きき</rt><rp>)</rp></ruby>「<ruby>濛々迷霧<rp>(</rp><rt>もうもうめいむ</rt><rp>)</rp></ruby>」](./strategy-EX.md#EX-7-鬼気「濛々迷霧」)|3|B|[th95_udx-7.rpy](./rpy/th95_udx-7.rpy)|
|EX-8|<ruby>伊吹<rp>(</rp><rt>いぶき</rt><rp>)</rp></ruby> <ruby>萃香<rp>(</rp><rt>すいか</rt><rp>)</rp></ruby>|[「<ruby>百万鬼夜行<rp>(</rp><rt>ひゃくまんきやこう</rt><rp>)</rp></ruby>」](./strategy-EX.md#EX-8-「百万鬼夜行」)|10|B|[th95_udx-8.rpy](./rpy/th95_udx-8.rpy)|

----

## 参考
