# Spec: 矩形攻击提示与实际判定统一

## 背景

M2 反馈中，攻击范围提示已从粗糙多边形改为矩形，用户确认矩形方向可接受。

当前遗留问题：

```text
显示范围是矩形，但实际攻击判定仍是圆形 AttackArea。
```

这会导致玩家看到的攻击范围和真实命中范围不一致，影响战斗可读性。

## 目标

- 将攻击显示范围和实际攻击判定统一为矩形。
- 保持当前近战短斩/戳击手感。
- 攻击提示继续跟随玩家朝向旋转。
- 攻击判定也跟随玩家朝向旋转。

## 非目标

- 不做扇形攻击。
- 不做多段攻击。
- 不做武器系统。
- 不做完整攻击动画。
- 不做最终美术特效。

## 当前问题

当前 `Player.tscn` 中：

- `AttackPreview` 是矩形视觉提示。
- `AttackArea/CollisionShape2D` 使用 `CircleShape2D`。

结果：

- 视觉看起来像前方矩形。
- 实际判定是圆形。
- 可能出现“看起来没打到但命中”或“看起来打到但没命中”的情况。

## 设计方案

### 1. 攻击判定改为矩形

将 `AttackArea/CollisionShape2D` 的 shape 从：

```text
CircleShape2D
```

改为：

```text
RectangleShape2D
```

建议尺寸：

```text
size = Vector2(50, 36)
```

与当前矩形提示：

```text
(-8, -18) -> (42, 18)
```

保持一致。

### 2. 攻击区域位置和旋转统一

攻击时：

```gdscript
attack_area.position = facing * (attack_range - 8.0)
attack_area.rotation = facing.angle()
attack_preview.position = attack_area.position
attack_preview.rotation = attack_area.rotation
```

这样视觉和判定统一。

### 3. 保留 attack_range 的成长能力

当前 `range_up` 会修改：

```gdscript
attack_range *= multiplier
```

短期方案：

- 攻击区域位置继续受 `attack_range` 影响。
- 矩形大小暂不随 range_up 扩大。

后续 M3 可将 `range_up` 改成：

- 增加矩形长度。
- 或增加 `RectangleShape2D.size.x`。
- 同步更新 `AttackPreview` polygon。

## 涉及文件

| 文件 | 改动 |
|---|---|
| `scenes/Player.tscn` | 攻击碰撞形状改为矩形 |
| `scripts/player.gd` | 攻击时同步设置 `AttackArea` 与 `AttackPreview` 的 position/rotation |
| `dev-log.md` | 记录实现过程 |
| `issue-tracker.md` | 更新 `FEEL-007` |

## 验收标准

- [ ] 攻击提示为矩形。
- [ ] 实际命中范围与矩形提示基本一致。
- [ ] 朝上/下/左/右攻击时，矩形提示和判定方向一致。
- [ ] 攻击仍能命中敌人。
- [ ] `range_up` 不导致报错。
- [ ] Godot 运行无脚本错误。

## 风险

| 风险 | 影响 | 应对 |
|---|---|---|
| 矩形过长 | 攻击过强 | 初始长度保持 50 |
| 矩形过窄 | 命中困难 | 初始高度保持 36 |
| range_up 只改距离不改大小 | 表现不完整 | 记录到 M3 构筑效果优化 |
| 手写 `.tscn` shape 配置错误 | 场景加载失败 | 修改后无头加载验证 |

## 实施步骤

1. 修改 `Player.tscn`：
   - 删除/替换圆形攻击 shape。
   - 增加矩形攻击 shape。
2. 修改 `player.gd`：
   - 攻击时同步设置 `attack_area.position`。
   - 攻击时同步设置 `attack_area.rotation`。
   - 攻击提示复用同样 position/rotation。
3. Godot 无头加载验证。
4. 更新 `dev-log.md`。
5. 更新 `issue-tracker.md`。
6. 用户复测。

## 回滚方案

如果矩形判定手感不好：

1. 保留矩形视觉。
2. 回滚实际判定为圆形。
3. 记录为 `FEEL-007` 后续处理。
