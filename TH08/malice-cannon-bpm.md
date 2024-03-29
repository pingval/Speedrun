<!-- TOC depthFrom:1 depthTo:2 -->

- [マリス砲に適したBPMを求めて](#マリス砲に適したbpmを求めて)
  - [調査方法](#調査方法)
  - [調査結果](#調査結果)

<!-- /TOC -->

# マリス砲に適したBPMを求めて

- あくまでメインは自分に適した連打速度の調査。
- 自分の低速ボタン連打時の押下時間は平均約3.5f(裏マリス砲は約5.6f)。

## 調査方法

- [DANAの部屋(消えてる…)](http://www.geocities.jp/dana13sai/)のSSGで無敵化
- [東方永夜抄Normal稼ぎ Wiki*(自分のサイト)のSSG](https://wikiwiki.jp/let/etc/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%A0%E3%81%AA%E3%81%A9/SpoilerAL%E7%94%A8%E3%81%AESSG%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB)で
  - 妖率100%に固定(実際のプレイでも~~アリス~~魔理沙の火力を上げるためにほぼ妖怪逢魔が時)
  - ダミー関数をON
  - アイテム出現ON/OFFで以下をOFF([刻符の回収によるSCB減少速度の変化](https://wikiwiki.jp/thk/%E6%B0%B8/Score#u1907091)を避けるため)
    - 使い魔破壊(#11)
    - 逢魔が時撃破時の刻符(#17)
    - かすり刻符(#43~45)
- 自機の位置はボスの真正面で最下段(実際のプレイでもほぼ最下段なので)

1. [メトロノーム](https://www.youtube.com/channel/UCzEkyKD5vboccdMipNQWY4w/playlists?view=50&sort=dd&shelf_id=3)に合わせて低速移動ボタンを連打し、撃破時のSCBを5回記録して平均をとる。
2. 別口で、準無敵解除までに与えたダメージも5回記録し平均をとる(元々はダメージ/sまで計算するつもりはなかったけど↑を元に計算しようと思ったらこれも必要になってしまった)。
```
撃破時間(f) = (初期SCB - 撃破時SCB) / SCB減少速度(点/f)
準無敵状態解除後の撃破時間(f) = 撃破時間(f) - 準無敵解除時間(f)
準無敵状態解除後に削った体力 = ボス体力 - 準無敵状態解除までの与ダメ
火力(ダメージ/s) = 準無敵状態解除後に削った体力 / 準無敵状態解除後の撃破時間(f) * 60
```
で1秒あたりのダメージが求まる。

### 調査に使ったスペルカード

- 季節外れのバタフライストーム
  - 普通のボス(慧音)を想定
- 蓬莱の樹海
  - 使い魔との同時撃ち込みを想定
- 正直者の死
  - 羽つき妹紅
  - 妹紅が不動なスペルでは蓬莱人形のほうが体力が多いが、スペルプラクティスでは羽を装備していない。なんでやねん。

----

## 調査結果

- [東方永夜抄 マリス砲とかの火力](https://docs.google.com/spreadsheets/d/1VXGjVePm8eVxLS8RdaF7gUEUMf7UCMTPxy0VWNt4StY/edit?usp=sharing)

### マリス砲のグラフ
- 190~240BPMで火力はほぼ等しいが、210BPMの火力が季節外れのバタフライストームと蓬莱の樹海ではMAX、正直者の死でもMAX-1なので、210BPMで連打することにする(結論)。
- BPMが180から170に下がると火力が急激に落ちてしまうので、最低でも180BPM以上の速度はほしい。210BPMは180BPMより充分速い。
- BPMが210を超えると火力は緩やかに減少してゆくが、300BPMでも180BPMのときの火力は確保される。連打は遅いよりは速いほうがマシ。
- 蓬莱の樹海で壊した使い魔の数は、160BPM以上では3匹だったが150BPM以下では4匹に増えていた。BPMが160から150で火力が大きく落ちているのは、使い魔が1匹減ったことでダメージが通りにくくなったせいだろう。

### マリス砲以外のグラフ
- `正直者の死のアリス(258) - 季節外れのバタフライストームのアリス(162) = 正直者の死のアリス→羽(96)`より、妹紅に対するアリスのレーザーは本体と羽の両方を通してダメージを与えていると考えられる。
- アリスのレーザーもレミリアのメインショットも、羽にさえ全部当たっていれば、妹紅の近くでも羽の端の方でも火力(撃破時間)は変わらなかった。

----

というわけで210BPMでいきます。

調査は全て、与ダメが通常の1/7(小数点以下切り捨て)になるスペルカードで行った。与ダメの除算のない通常攻撃では結果が変わる可能性もあるが、調査環境を整えるのがめんどいのでおわり。
