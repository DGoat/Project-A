# Spec 015：近战敌人 NavigationAgent2D 寻路 0.1

## 背景

地图地形 0.1 中，硬障碍已能阻挡玩家、敌人和投射物。但敌人原本是直线追击，遇到障碍后容易卡住。轻量 steering 可以缓解，但随着障碍增加会不稳定。

本轮将近战敌人优先迁移到 Godot `NavigationAgent2D`，为后续复杂地图打基础。

## 本轮目标

1. 为当前房间生成可行走导航区域。
2. 将硬障碍从导航区域中排除。
3. 近战敌人使用 `NavigationAgent2D` 获取下一路径点追击玩家。
4. 保留敌人间分离，避免单位重叠。
5. 远程敌人暂不迁移，避免 preferred distance 逻辑同时复杂化。

## 非目标

- 不做完整远程敌人导航。
- 不做动态障碍导航重烘焙。
- 不做程序化地图。
- 不增加新美术资源。

## 实现方案

### Main

在 `MapRoot` 下动态生成：

```text
NavigationRegion2D
```

每次切房间：

1. 清空旧地图元素。
2. 根据房间障碍配置生成 `NavigationPolygon`。
3. 外轮廓为可移动桌面区域。
4. 每个硬障碍按尺寸加 margin 后作为洞加入导航多边形。
5. 再生成硬障碍和胶水坑。

### MeleeEnemy

场景增加：

```text
NavigationAgent2D
```

脚本逻辑：

- 每帧设置 `navigation_agent.target_position = player.global_position`。
- 读取 `get_next_path_position()`。
- 朝下一路径点移动。
- recoil / knockback 仍优先于导航。
- 敌人分离速度继续保留。

### 验收标准

1. 近战敌人被障碍阻挡时会尝试绕行，而不是只贴在障碍上。
2. 敌人仍会追击玩家。
3. 近战命中玩家后的 recoil 仍正常。
4. 敌人间分离仍正常。
5. 远程敌人行为不回退。
6. `tests/smoke_test.gd` 输出 `AI_TEST_PASS`。

## 风险

- Godot 导航多边形洞的方向/生成规则若异常，可能需要调整轮廓 winding。
- 如果障碍离导航边界太近，可能导致局部导航区域断裂。
- 本轮只保证当前三房间小规模障碍有效。
