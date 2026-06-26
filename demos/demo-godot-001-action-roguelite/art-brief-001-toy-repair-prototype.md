# Art Brief 001: 玩具修理屋 Prototype 资产包

## 目标

生成第一批最小美术资源，用来验证“童话治愈 × 玩具修理屋”主题是否能在当前俯视角 2D 动作 Roguelite 中成立。

这批资源不是最终美术，目标是：

- 一眼看出主角是“小修理师”。
- 一眼看出敌人是“失控玩具”。
- 攻击、投射物、背景能传达修理屋/玩具箱语义。
- 接入 Godot 后仍保持战斗可读性。

## 统一风格

关键词：

```text
童话治愈、夜晚修理屋、温暖灯光、手作玩具、木头、布料、发条、纽扣、螺丝、轻微旧物感、可爱但不幼稚
```

画面气质：

- 温暖，不恐怖。
- 有夜晚感，但不要太暗。
- 童话绘本感优先于写实。
- 形状清楚，适合小尺寸动作游戏。
- 俯视角 / 轻微 3/4 俯视角均可。

不希望出现：

- 写实恐怖玩偶。
- 过度赛博/机械硬科幻。
- 太像《玩具总动员》的具体角色。
- 太复杂的纹理和细节。
- 背景与角色对比太低。

## 技术规格

| 资源 | 建议尺寸 | 背景 | 用途 |
|---|---:|---|---|
| `player_repairer.png` | 96x96 | 透明 | 玩家主角 |
| `enemy_block_soldier.png` | 80x80 | 透明 | 近战敌人 |
| `enemy_spring_cannon.png` | 80x80 | 透明 | 远程敌人 |
| `projectile_button.png` | 24x24 | 透明 | 远程投射物 |
| `attack_wood_ruler.png` | 128x64 | 透明 | 近战攻击提示 |
| `bg_repair_table.png` | 1024x640 | 不透明 | 战斗背景 |

推荐目录：

```text
demos/demo-godot-001-action-roguelite/assets/art/toy-repair-prototype/
```

## 资源清单与 Prompt

### 1. 玩家：小修理师

文件名：

```text
player_repairer.png
```

用途：替换当前玩家绿色几何体。

视觉要求：

- 小小修理师 / 发条修理精灵。
- 戴小围裙，背小工具包。
- 手持小木锤或小扳手。
- 头顶或胸前有温暖小灯。
- 朝右，方便 Godot 旋转朝向。
- 轮廓清晰，小尺寸仍可读。

中文 Prompt：

```text
童话治愈风格的2D游戏角色，小小玩具修理师，轻微俯视角，朝右站立，戴青绿色小围裙，背着小工具包，手里拿着小木锤或小扳手，头顶有温暖的小灯，温暖夜晚修理屋氛围，可爱但不幼稚，手绘绘本质感，清晰轮廓，适合俯视角动作游戏，透明背景，单个角色，无文字，无阴影背景
```

English Prompt：

```text
cozy fairytale 2D game character, tiny toy repairer, slight top-down view, facing right, teal apron, small tool bag, holding a tiny wooden hammer or wrench, warm little headlamp, nighttime toy repair shop mood, cute but not childish, hand-painted storybook style, clear readable silhouette, suitable for top-down action game, transparent background, single character, no text, no background shadow
```

Negative Prompt：

```text
realistic, horror doll, creepy, cyberpunk, sci-fi armor, complex background, text, logo, weapon gore, blood, low contrast, too many details
```

---

### 2. 近战敌人：失控积木兵

文件名：

```text
enemy_block_soldier.png
```

用途：替换近战追击敌人。

视觉要求：

- 红棕色或木色积木兵。
- 有积木块拼接感。
- 表情可以生气但不要恐怖。
- 手持小木棍或积木剑。
- 轮廓偏方，区别于玩家。
- 朝右。

中文 Prompt：

```text
童话治愈风格的2D游戏敌人，失控积木兵，轻微俯视角，朝右，红棕色木头积木身体，积木块拼接结构，圆纽扣眼睛，表情有点生气但不可怕，手持小木棍或积木剑，温暖夜晚修理屋氛围，清晰轮廓，适合俯视角动作游戏，透明背景，单个角色，无文字
```

English Prompt：

```text
cozy fairytale 2D game enemy, runaway block soldier toy, slight top-down view, facing right, reddish brown wooden block body, built from simple toy blocks, round button eyes, slightly angry but not scary, holding a tiny wooden stick or block sword, warm nighttime repair shop mood, clear readable silhouette, suitable for top-down action game, transparent background, single character, no text
```

Negative Prompt：

```text
horror, creepy doll, realistic violence, blood, sharp monster teeth, complex background, text, logo, too detailed, low contrast
```

---

### 3. 远程敌人：弹簧炮玩具

文件名：

```text
enemy_spring_cannon.png
```

用途：替换远程射手敌人。

视觉要求：

- 铁皮蓝或蓝绿色玩具炮。
- 有弹簧、发条、炮口元素。
- 像坏掉的玩具，不像真实武器。
- 朝右，炮口朝右。
- 轮廓明显区别于近战积木兵。

中文 Prompt：

```text
童话治愈风格的2D游戏敌人，坏掉的弹簧炮玩具，轻微俯视角，朝右，铁皮蓝色小玩具炮，带弹簧尾巴和小发条，炮口圆润不可怕，像儿童玩具而不是真实武器，温暖夜晚修理屋氛围，清晰轮廓，适合俯视角动作游戏，透明背景，单个物体，无文字
```

English Prompt：

```text
cozy fairytale 2D game enemy, broken spring cannon toy, slight top-down view, facing right, tin blue toy cannon, with spring tail and small wind-up key, rounded harmless barrel, looks like a children's toy not a real weapon, warm nighttime toy repair shop mood, clear readable silhouette, suitable for top-down action game, transparent background, single object, no text
```

Negative Prompt：

```text
real gun, military cannon, realistic weapon, horror, dark sci-fi, complex background, text, logo, low contrast, too detailed
```

---

### 4. 投射物：纽扣弹

文件名：

```text
projectile_button.png
```

用途：替换远程敌人弹体。

视觉要求：

- 小纽扣 / 小螺丝感觉。
- 圆形，2 到 4 个孔。
- 高对比，小尺寸可读。
- 透明背景。

中文 Prompt：

```text
2D游戏小投射物图标，童话修理屋风格，一个小纽扣弹，圆形黄铜纽扣，两个或四个纽扣孔，轻微手绘质感，清晰轮廓，高对比，适合24x24像素游戏投射物，透明背景，无文字
```

English Prompt：

```text
2D game projectile icon, cozy toy repair shop style, small button projectile, round brass button, two or four button holes, slight hand-painted texture, clear silhouette, high contrast, suitable for 24x24 game projectile, transparent background, no text
```

Negative Prompt：

```text
bullet, real ammo, blood, complex background, text, logo, low contrast, too detailed
```

---

### 5. 攻击提示：木尺挥击

文件名：

```text
attack_wood_ruler.png
```

用途：替换当前半透明矩形攻击范围提示。

视觉要求：

- 横向木尺 / 木工工具扫过区域。
- 半透明效果可在 Godot 内调，也可 PNG 自带透明。
- 有简单刻度线。
- 左端靠近玩家，右端为攻击方向。
- 不要太花，避免遮挡。

中文 Prompt：

```text
2D游戏攻击范围提示，童话玩具修理屋风格，横向木尺挥击效果，暖棕色木尺，带简单刻度线，轻微运动拖尾，适合俯视角近战攻击范围，透明背景，半透明质感，无文字，无角色
```

English Prompt：

```text
2D game attack range indicator, cozy toy repair shop style, horizontal wooden ruler swing effect, warm brown wooden ruler, simple measurement marks, slight motion trail, suitable for top-down melee attack range, transparent background, semi-transparent feel, no text, no character
```

Negative Prompt：

```text
sword slash, blood, fire explosion, complex background, text, logo, too bright, too opaque, realistic weapon
```

---

### 6. 背景：夜晚修理台 / 玩具箱内部

文件名：

```text
bg_repair_table.png
```

用途：替换 Arena 冷黑背景，作为战斗区域底图或参考图。

视觉要求：

- 16:10 或接近当前 Arena 比例。
- 夜晚修理台 / 玩具箱内部。
- 暖暗棕木桌面。
- 边缘有少量装饰：线轴、纽扣、螺丝、布片、积木、发条。
- 中央区域留空，保证战斗可读。
- 不要过于复杂。

中文 Prompt：

```text
童话治愈风格2D游戏战斗背景，夜晚玩具修理台或玩具箱内部，轻微俯视角，暖暗棕色木桌面，温暖台灯光，边缘散落少量线轴、纽扣、螺丝、布片、积木和发条，中央区域留空用于战斗，手绘绘本质感，柔和但清晰，1024x640，无角色，无文字
```

English Prompt：

```text
cozy fairytale 2D game battle background, nighttime toy repair table or inside a toy box, slight top-down view, warm dark brown wooden tabletop, warm desk lamp light, a few spools, buttons, screws, fabric patches, toy blocks and wind-up keys around the edges, empty center area for combat readability, hand-painted storybook texture, soft but clear, 1024x640, no characters, no text
```

Negative Prompt：

```text
busy cluttered center, horror, creepy dolls, realistic photo, dark unreadable image, text, logo, characters, too many details, low contrast
```

## 推荐生成顺序

1. `bg_repair_table.png`
2. `player_repairer.png`
3. `enemy_block_soldier.png`
4. `enemy_spring_cannon.png`
5. `projectile_button.png`
6. `attack_wood_ruler.png`

原因：先确定背景和主角风格，再生成敌人与小件，统一性更好。

## Godot 接入计划

第一步只接静态图：

| 资源 | 接入方式 |
|---|---|
| 玩家 | `Sprite2D` 替代/覆盖 `Player/Body` |
| 近战敌人 | `Sprite2D` 替代/覆盖 `MeleeEnemy/Body` |
| 远程敌人 | `Sprite2D` 替代/覆盖 `RangedEnemy/Body` |
| 投射物 | `Sprite2D` 替代/覆盖 `Projectile/Body` |
| 攻击提示 | `Sprite2D` 替代/覆盖 `AttackPreview` 或保留 Polygon 作为 fallback |
| 背景 | `TextureRect` 或 `Sprite2D` 放在 Arena 区域 |

保留所有碰撞体与脚本逻辑不变。

## 验收标准

- [ ] 角色、敌人、投射物一眼能看出玩具修理屋主题。
- [ ] 战斗中玩家和敌人仍清晰区分。
- [ ] 攻击范围仍清楚。
- [ ] 背景不干扰战斗。
- [ ] 3 房间流程仍可通关。

## 备注

第一批资源用于验证方向，不要求最终质量。若风格成立，再进入：

```text
Art Pass 0.2：idle / hit / dash / attack 简单帧动画
```
