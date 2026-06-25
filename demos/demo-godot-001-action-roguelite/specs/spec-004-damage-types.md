# Spec: 伤害类型与击退规则

## 背景

M2 基础手感强化后，敌人受击会产生 knockback。用户复测反馈：

```text
敌人受击有后退了，但是需要区分伤害类型，像燃烧伤害就不应该造成后退。
```

当前问题：

- 直接攻击伤害和燃烧 DoT 都走 `take_damage(amount, source)`。
- `take_damage()` 只要有 `source` 就触发 knockback。
- 燃烧 tick 伤害也带有 `burn_owner`，因此可能造成不合理后退。

需要引入轻量伤害类型，区分：

- 直接命中伤害：可以击退。
- 燃烧/持续伤害：不应该击退。

## 目标

- 引入轻量 `damage_type` 参数。
- 普通攻击造成 knockback。
- Dash Strike 仍然造成 knockback。
- 燃烧伤害不造成 knockback。
- 不重构完整伤害系统。

## 非目标

- 不做完整伤害结算器。
- 不做抗性/元素系统。
- 不做暴击、护甲、易伤等复杂规则。
- 不新增伤害数字 UI。
- 不改变当前伤害数值。

## 范围

涉及：

- `melee_enemy.gd`
- `ranged_enemy.gd`
- `player.gd`
- `issue-tracker.md`
- `dev-log.md`

## 设计方案

### 伤害类型

使用字符串参数：

```gdscript
func take_damage(amount: int, source: Node = null, damage_type := "direct") -> void:
```

当前类型：

| damage_type | 含义 | 是否击退 |
|---|---|---|
| `direct` | 普通攻击 / 强化攻击 | 是 |
| `burn` | 燃烧持续伤害 | 否 |

### 玩家攻击

玩家攻击敌人时：

```gdscript
body_node.take_damage(int(round(damage)), self, "direct")
```

### 燃烧伤害

敌人处理 burn tick 时：

```gdscript
take_damage(burn_damage, burn_owner, "burn")
```

### 敌人 take_damage

只有 `damage_type == "direct"` 且 `source != null` 时触发 knockback。

```gdscript
if damage_type == "direct" and source != null:
    knockback_direction = source.global_position.direction_to(global_position).normalized()
    knockback_time = knockback_duration
```

## 涉及文件

| 文件 | 改动 |
|---|---|
| `scripts/player.gd` | 玩家攻击传入 `direct` |
| `scripts/melee_enemy.gd` | `take_damage` 增加 `damage_type`，burn tick 传入 `burn` |
| `scripts/ranged_enemy.gd` | 同上 |
| `issue-tracker.md` | 新增/更新伤害类型问题 |
| `dev-log.md` | 记录实现过程 |

## 验收标准

- [ ] 普通攻击命中敌人仍会造成后退。
- [ ] Dash Strike 命中敌人仍会造成后退。
- [ ] 燃烧 tick 不会造成敌人后退。
- [ ] 燃烧伤害仍会扣血并能击杀敌人。
- [ ] 击杀回血逻辑不受影响。
- [ ] Godot 运行无脚本错误。

## 风险

| 风险 | 影响 | 应对 |
|---|---|---|
| 修改函数签名遗漏调用点 | 脚本报错 | 搜索所有 `take_damage(` 调用点 |
| burn 击杀不触发 kill heal | 构筑失效 | 保留 `burn_owner`，只禁用 knockback |
| 字符串类型拼写错误 | 规则不生效 | 当前只用 `direct` / `burn` 两个常量字符串 |

## 实施步骤

1. 修改 `player.gd` 普攻调用。
2. 修改 `melee_enemy.gd`：
   - `take_damage` 增加 `damage_type`。
   - 仅 direct 触发 knockback。
   - burn tick 传入 `burn`。
3. 修改 `ranged_enemy.gd` 同上。
4. 搜索调用点确认无遗漏。
5. Godot 无头加载验证。
6. 更新日志与问题追踪。

## 回滚方案

如果伤害类型引起问题：

1. 回退函数签名。
2. 暂时在 burn tick 前清空 `source`，避免 knockback。
3. 后续再重做伤害类型。
