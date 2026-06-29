# Spec 021：远程敌人 NavigationAgent2D 寻路 0.1

## 背景

近战敌人已迁移到 `NavigationAgent2D`，绕障碍能力明显提升。当前远程敌人仍使用直线移动 + steering，遇到硬障碍时也可能卡住或位置选择不自然。

本轮给远程敌人接入同样的导航基础，但保留远程敌人的距离控制逻辑。

## 本轮目标

1. 远程敌人增加 `NavigationAgent2D`。
2. 远程敌人靠近/远离玩家时，沿导航路径移动。
3. 保留 preferred distance 逻辑。
4. 保留射击、受击、死亡、敌人分离。
5. 不改变远程敌人射击频率和伤害。

## 非目标

- 不做复杂找点算法。
- 不做掩体 AI。
- 不做远程敌人绕障碍选射击角。
- 不改 projectile 逻辑。

## 实现方案

### RangedEnemy.tscn

增加：

```text
NavigationAgent2D
```

### ranged_enemy.gd

根据距离计算目标点：

- 距离过近：目标点为远离玩家方向的一段位置。
- 距离过远：目标点为玩家位置。
- 距离合适：不移动。

移动时：

```gdscript
navigation_agent.target_position = target_position
var next_position = navigation_agent.get_next_path_position()
velocity = direction_to(next_position) * move_speed
```

继续叠加敌人分离速度。

## 验收标准

1. 远程敌人能绕硬障碍靠近或拉开距离。
2. 远程敌人保持 preferred distance 行为不明显回退。
3. 远程敌人射击正常。
4. `tests/smoke_test.gd` 输出 `AI_TEST_PASS`。
