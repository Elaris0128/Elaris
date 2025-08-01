以下為術式結構運算規則之初階設計草案，聚焦於模組語法系統。

---

## 🧩 術式模組語法設計（Modular Spell Construction）

術式不再為單一句子或固定招式，而是由多個模組拼組構成。此設計允許術者依照情境、靈息與誓環狀況調整施法流程，建立高自由度與個性化的法術運用方式。

### 📘 結構語法格式：
```
【引息】→【導式】→【轉式（可省略）】→【釋式】→【誓印/誓意（可附加）】
```

### 🔧 模組分類與功能

| 模組類型 | 功能 | 範例 | 附註 |
|----------|------|------|------|
| 引息（Veiren Draw） | 喚起特定靈息作為術式基源 | 引心息／引炎息／引地息 | 多靈息時需標註主副之分 |
| 導式（Channel） | 決定術式流向與附著目標 | 導向地面／武器／靈獸 | 附著型、範圍型、靈體型 |
| 轉式（Flux） | 對靈息進行轉質、結構改寫 | 星→光暈／炎→熾網 | 需掌握「轉質結構術式」學識 |
| 釋式（Discharge） | 釋放術式能量或召喚物 | 爆散／束射／鎖定召喚 | 成功與否依靈息穩定度 |
| 誓印（Oath Embed） | 注入誓環，觸發誓信或強化誓式 | 誓獸應響／誓場共鳴 | 可產生術式連動或誓息共振 |

---

## ⚔️ 戰技模組語法設計（Martial Invocation Design）

與術式不同，戰技為「不透過術式結構、僅依靈息呼應」之技能，屬於原能引導。使用者可將靈息灌注於動作、兵器或意志流動中，形成戰場技巧或靈技效應。

### 📘 結構語法格式：
```
【引息】→【體式】→【灌注】→【擊型／行勢】→【殘效（可選）】
```

### 🔧 模組分類與功能

| 模組類型 | 功能 | 範例 | 附註 |
|----------|------|------|------|
| 引息（Veiren Surge） | 聚集體內靈息作為戰技驅動 | 引炎息／引地息 | 通常僅使用單一主靈息 |
| 體式（Form） | 動作起始架式或引導勢態 | 破岩式／啟空式／靜心架 | 影響戰技穩定度與速度 |
| 灌注（Infuse） | 將靈息注入特定部位或武器 | 灌掌／灌刃／灌足 | 與武技熟練度關聯 |
| 擊型（Impact）或 行勢（Flow） | 實際動作形態與對敵效果 | 重擊／連掃／穿刺旋斬 | 多為物理＋靈性混合輸出 |
| 殘效（Aftereffect） | 技後衍生效應或領域殘留 | 炎痕／氣爆／震氣餘波 | 戰技風格象徵性特徵 |

---

兩套模組系統可於某些特殊職系中交叉（如誓武者、符刃使），但基本上術式模組偏向靈息結構與誓環運作，戰技模組則強調靈息掌控與身體應用。

接續是否需要設定「模組詞庫」、「職業搭配規則」或「誓環模組互動」？