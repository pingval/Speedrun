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

- Level 1
- Level 2
- Level 3
- Level 4
- Level 5
- Level 6
- Level 7
- Level 8
- Level 9
- Level 10
- Level EX

----

## 参考文献