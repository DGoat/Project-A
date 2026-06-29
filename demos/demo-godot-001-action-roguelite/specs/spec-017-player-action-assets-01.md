# Spec 017：主角动作资源规划 0.1

## 背景

当前主角表现已通过 bob、缩放、残影、抖动等伪动画提升可读性，但仍然只有单张正面图。手测反馈明确指出：

- 主角移动仍不像真正动作。
- 攻击仍依赖木尺表现，主角自身没有攻击姿态。
- 受击、死亡更希望有明确动作，死亡尤其希望是倒下动画。

本轮目标不是接入资源，而是明确下一批主角动作资源清单、命名、规格和生成提示词。

## 本轮目标

1. 规划主角最小动作资源集。
2. 保持当前单 PNG 接入方式，避免一次引入复杂 Sprite Sheet。
3. 给出可直接生成图片的提示词。
4. 明确资源放置路径与命名。
5. 为后续 Animation 0.2 接入做准备。

## 非目标

- 不实现帧动画系统。
- 不接入骨骼动画。
- 不马上替换当前主角图。
- 不要求 8 方向完整动画。

## 资源路径

建议放置：

```text
demos/demo-godot-001-action-roguelite/assets/art/toy_repair_prototype/player_actions/
```

## 最小动作资源集

### 1. `player_idle.png`

用途：站立/默认状态，替换当前主角单图。

尺寸建议：

```text
512x512，透明背景
```

中文 Prompt：

```text
童话治愈风格的小小玩具修理师角色，夜晚玩具修理屋主题，正面略微四分之三视角，穿小围裙，手持小木尺或小螺丝刀，温暖台灯光，绘本手绘质感，清晰轮廓，适合2D俯视动作Roguelite主角，透明背景，单角色完整身体，不包含文字
```

English Prompt：

```text
a tiny cozy toy repairer character for a fairy-tale night toy repair shop game, slight three-quarter front view, wearing a small apron, holding a tiny wooden ruler or screwdriver, warm lamp light, hand-painted storybook style, clean silhouette, suitable for a 2D top-down action roguelite player character, transparent background, full body single character, no text
```

### 2. `player_walk_lean.png`

用途：移动时替换/叠加，表现身体前倾和迈步。

中文 Prompt：

```text
童话治愈风格的小小玩具修理师正在小跑，身体轻微前倾，一只脚迈出，围裙和小工具有轻微动感，夜晚玩具修理屋主题，温暖台灯光，绘本手绘质感，清晰轮廓，适合2D俯视动作Roguelite移动姿态，透明背景，单角色完整身体，不包含文字
```

English Prompt：

```text
a tiny cozy toy repairer running lightly, body leaning forward, one foot stepping out, apron and small tools showing subtle motion, night toy repair shop theme, warm lamp light, hand-painted storybook style, clean silhouette, suitable for a 2D top-down action roguelite movement pose, transparent background, full body single character, no text
```

### 3. `player_attack_pose.png`

用途：攻击瞬间主角姿态，配合现有木尺攻击图。

中文 Prompt：

```text
童话治愈风格的小小玩具修理师挥出木尺修理打击，身体旋转发力，手臂伸出，动作清晰有冲击感但不暴力，夜晚玩具修理屋主题，温暖台灯光，绘本手绘质感，清晰轮廓，适合2D俯视动作Roguelite攻击姿态，透明背景，单角色完整身体，不包含文字
```

English Prompt：

```text
a tiny cozy toy repairer swinging a wooden ruler for a repair strike, body twisting with force, arm extended, clear impact pose but non-violent, night toy repair shop theme, warm lamp light, hand-painted storybook style, clean silhouette, suitable for a 2D top-down action roguelite attack pose, transparent background, full body single character, no text
```

### 4. `player_hurt_pose.png`

用途：受击短暂替换，增强受击识别。

中文 Prompt：

```text
童话治愈风格的小小玩具修理师受击后踉跄，身体后仰，表情惊讶但可爱，没有伤口和血，围裙和工具轻微甩动，夜晚玩具修理屋主题，温暖台灯光，绘本手绘质感，清晰轮廓，适合2D俯视动作Roguelite受击姿态，透明背景，单角色完整身体，不包含文字
```

English Prompt：

```text
a tiny cozy toy repairer staggering after being hit, body leaning backward, surprised but cute expression, no wounds and no blood, apron and tools slightly swinging, night toy repair shop theme, warm lamp light, hand-painted storybook style, clean silhouette, suitable for a 2D top-down action roguelite hurt pose, transparent background, full body single character, no text
```

### 5. `player_down_pose.png`

用途：死亡/失败时倒下动画终帧。

中文 Prompt：

```text
童话治愈风格的小小玩具修理师疲惫地倒在修理台上，侧躺或半趴姿态，小木尺掉在旁边，小灯光温柔，不恐怖，不受伤，没有血，像玩具修理师累倒睡着，夜晚玩具修理屋主题，绘本手绘质感，清晰轮廓，适合2D俯视动作Roguelite失败倒下姿态，透明背景，单角色完整身体，不包含文字
```

English Prompt：

```text
a tiny cozy toy repairer collapsed tiredly on a repair table, lying on the side or half-prone, small wooden ruler dropped nearby, gentle warm lamp light, not scary, no injury, no blood, feels like the repairer fell asleep from exhaustion, night toy repair shop theme, hand-painted storybook style, clean silhouette, suitable for a 2D top-down action roguelite defeat pose, transparent background, full body single character, no text
```

## 通用 Negative Prompt

```text
text, logo, watermark, realistic photo, horror, gore, blood, injury, scary face, cyberpunk, complex background, low contrast, blurry, noisy, cropped body, multiple characters
```

## 接入策略

### Animation 0.2 最小接入

- `player_idle.png`：默认 Body texture。
- 移动时：根据速度切到 `player_walk_lean.png`，停止后切回 idle。
- 攻击时：短暂切到 `player_attack_pose.png`，攻击结束后回 idle / walk。
- 受击时：短暂切到 `player_hurt_pose.png`。
- 死亡时：切到 `player_down_pose.png`，再淡出或保留倒地图。

### 仍保留现有效果

- Dash 残影保留。
- 攻击木尺保留。
- 受击抖动保留，但幅度可降低。
- 死亡缩小淡出可改为轻微倒地 + 停留。

## 验收标准

1. 用户可按提示词生成 5 张主角动作图。
2. 文件命名和放置路径明确。
3. 后续接入时不需要重新设计动作清单。
4. 不阻塞当前可玩版本。
