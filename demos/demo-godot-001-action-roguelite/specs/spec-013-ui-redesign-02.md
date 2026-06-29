# Spec 013：UI Redesign 0.2

## 背景

UI Polish 0.1 已经让界面摆脱了一部分 Godot 默认控件感，但手测反馈显示仍存在几个核心问题：

1. 标题层级区分不明显，缺少像参考图那样强烈的标题识别。
2. 三选一修理灵感仍是竖排列表，不符合 Roguelite 三选一的期待；应改为横向三卡并列，类似《英雄联盟》海克斯选择。
3. Debug 面板暂时可以保留现状。
4. HUD 仍然太粗糙，需要重新设计信息层级。

本轮目标是先明确 UI 方向、布局、可直接生成的 UI 图片资源需求与提示词，再进入实现。

## 参考方向提炼

### 标题层级

参考《空洞骑士》《Beyond Time》《Arco》：

- 大标题应占据视觉中心，有明确轮廓、装饰和发光/阴影。
- 副标题比主标题小很多，起说明作用，不抢视觉中心。
- 菜单按钮应像“选项列表”或“木牌按钮”，而不是普通表单按钮。

### 三选一卡片

参考海克斯选择：

- 三个选项横向并列。
- 每个选项是独立大卡片。
- 卡片有图标区、名称区、标签区、描述区。
- 当前选择/hover 状态有明显边框或高光。
- 键位提示 `1 / 2 / 3` 应放在卡片底部或角标。

### HUD

当前 HUD 问题：

- 文字直接叠在背景上，缺少结构。
- HP、区域、敌人数量混在一行，阅读层级差。
- 操作提示长期存在，压画面。

建议方向：

- 左上角做“小木牌 HUD”。
- HP 独立为小红心/纽扣血条。
- 区域与失控玩具数量作为第二层小字。
- 操作提示改为低透明底部/左下角短提示，或开局显示，之后弱化。

## 本轮目标

- 重做开始界面标题层级。
- 三选一修理灵感改为横向三卡。
- HUD 改为结构化木牌/布片风格。
- 结算界面沿用新标题层级。
- Debug 面板暂不大改。
- 先支持纯 Godot 样式实现；若用户生成 UI 资源，则替换为图片资源。

## 非目标

- 不做完整菜单系统。
- 不做设置界面。
- 不做动态 UI 动画大片。
- 不强依赖新图片资源；图片资源作为增强项。

## 推荐新增 UI 图片资源

如果要明显接近参考图质量，建议生成以下 4 类资源。

### 1. `ui_title_ornament.png`

用途：开始界面和结算界面的标题装饰，放在标题上下方。

尺寸建议：

```text
1024x256，透明背景
```

中文 Prompt：

```text
童话治愈风格的标题装饰条，夜晚玩具修理屋主题，温暖台灯光，木雕与布片纹理结合，左右对称，细腻卷草纹，纽扣、发条、小螺丝、缝线元素，适合游戏主菜单标题下方装饰，透明背景，手绘绘本质感，高对比，干净轮廓，不包含文字
```

English Prompt：

```text
fairy-tale cozy title ornament for a night toy repair shop game, warm lamp light, carved wood and stitched fabric texture, symmetrical horizontal flourish, tiny buttons, clockwork gears, screws and sewing stitches, suitable below a game title, transparent background, hand-painted storybook style, clean silhouette, high contrast, no text
```

Negative Prompt：

```text
text, logo, watermark, realistic photo, horror, gore, cyberpunk, complex background, low contrast, blurry, noisy
```

### 2. `ui_blessing_card_frame.png`

用途：三选一修理灵感卡片边框。

尺寸建议：

```text
512x768，透明背景
```

中文 Prompt：

```text
童话治愈风格的竖版卡牌边框，夜晚玩具修理屋主题，木质卡框，布片内衬，暖黄色边缘光，顶部有小圆形图标槽，底部有小木牌键位槽，纽扣、缝线、发条、小螺丝装饰，透明背景，中间留空用于文字，手绘绘本质感，清晰轮廓，不包含文字
```

English Prompt：

```text
vertical card frame for a cozy toy repair shop roguelite blessing choice, wooden frame, stitched fabric inner panel, warm golden rim light, circular icon slot at top, small wooden key prompt slot at bottom, decorated with buttons, stitches, clockwork gears and tiny screws, transparent background, empty center for text, hand-painted storybook style, clean silhouette, no text
```

Negative Prompt 同上。

### 3. `ui_hud_wood_plaque.png`

用途：左上角 HUD 底板。

尺寸建议：

```text
640x180，透明背景
```

中文 Prompt：

```text
童话治愈风格的游戏 HUD 木牌底板，夜晚玩具修理屋主题，横向小木牌，柔和暖灯边缘光，布片和缝线点缀，左侧有心形纽扣槽，右侧有小标签区域，透明背景，中间留空用于文字和血量，手绘绘本质感，清晰轮廓，不包含文字
```

English Prompt：

```text
cozy fairy-tale game HUD wooden plaque, night toy repair shop theme, horizontal small wooden sign, warm lamp rim light, stitched fabric accents, heart-shaped button slot on the left, small tag area on the right, transparent background, empty center for text and health, hand-painted storybook style, clean silhouette, no text
```

Negative Prompt 同上。

### 4. `ui_button_wood.png`

用途：开始/重开按钮底图。

尺寸建议：

```text
512x128，透明背景
```

中文 Prompt：

```text
童话治愈风格的木牌按钮，夜晚玩具修理屋主题，横向圆角木牌，暖黄色描边，轻微布片和缝线装饰，透明背景，中间留空用于文字，手绘绘本质感，清晰轮廓，不包含文字
```

English Prompt：

```text
cozy fairy-tale wooden button for a night toy repair shop game UI, horizontal rounded wooden sign, warm golden outline, subtle stitched fabric decoration, transparent background, empty center for text, hand-painted storybook style, clean silhouette, no text
```

Negative Prompt 同上。

## 无新资源时的实现方案

若暂时不生成新资源，先用 Godot 控件实现：

### 开始界面

- StartPanel 改为无大矩形压暗，或更小更透明。
- Title 字号提升到 44-56。
- Title 使用暖白/暖黄 + 强阴影。
- Subtitle 放到 Title 下方，字号 18-22。
- Controls 移到底部或弱化。
- StartButton 居中，宽度收窄。

### 三选一界面

结构改为：

```text
BlessingPanel
└── BlessingRoot VBox
    ├── Title Label
    └── CardRow HBox
        ├── Blessing1 Button
        ├── Blessing2 Button
        └── Blessing3 Button
```

卡片布局：

```text
[标签]
名称

描述

按 1 选择
```

卡片尺寸建议：

```text
宽 240-280，高 300-360
```

### HUD

拆分为：

```text
HudPanel PanelContainer
└── VBox
    ├── HP Label
    └── Room Label
```

ControlsHint：

- 放到屏幕下方或左下角。
- Alpha 降低。
- Start 后可进一步淡化。

## 本轮验收标准

1. 开始界面标题有明显主次层级。
2. 三选一修理灵感为横向三卡并列。
3. 三张卡片的标签、名称、描述、键位提示清楚。
4. HUD 不再是一行裸文字，至少有结构化底板。
5. Debug 面板仍可显示/隐藏。
6. 鼠标点击和 `1/2/3` 选择不受影响。
7. `tests/smoke_test.gd` 仍输出 `AI_TEST_PASS`。

## 推荐执行顺序

1. 先用 Godot 控件完成无资源版 UI 0.2。
2. 用户生成 UI 图片资源。
3. 再接入图片资源替换边框/底板/标题装饰。

## 当前建议

先实现无资源版 UI 0.2：横向三卡 + HUD 重排 + 标题层级增强。图片资源之后作为 UI 0.3 质感升级。
