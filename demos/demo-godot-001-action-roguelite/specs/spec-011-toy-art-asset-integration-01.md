# Spec 011：Toy Art Asset Integration 0.1

## 背景

Toy Visual Pass 0.1 的纯几何占位未能传达“童话治愈 × 玩具修理屋”主题。已生成第一批 PNG 美术资源，本轮目标是将资源接入 Godot，验证主题识别度是否明显提升。

## 目标

- 用 PNG 资源替换主要几何占位视觉。
- 保留现有玩法、碰撞、数值和 UI Flow。
- 不在本轮深化构筑机制。
- 不调整房间流程和敌人行为。

## 接入资源

```text
assets/art/toy_repair_prototype/player_repairer.png
assets/art/toy_repair_prototype/enemy_block_soldier.png
assets/art/toy_repair_prototype/enemy_spring_cannon.png
assets/art/toy_repair_prototype/projectile_button.png
assets/art/toy_repair_prototype/attack_wood_ruler.png
assets/art/toy_repair_prototype/bg_repair_table.png
```

## 改动范围

### Main.tscn

- 增加修理台背景图层。
- 保留原 Arena 色块作为暗色底。

### Player.tscn / player.gd

- 主角视觉改为 `player_repairer.png`。
- 保留角色碰撞圆、头顶血条、攻击判定。
- 攻击时额外显示 `attack_wood_ruler.png`，与矩形判定同步出现/消失。

### MeleeEnemy.tscn / melee_enemy.gd

- 近战敌人视觉改为 `enemy_block_soldier.png`。
- 保留碰撞、接触伤害、recoil、knockback、burn 逻辑。
- 精英敌人继续放大显示。

### RangedEnemy.tscn / ranged_enemy.gd

- 远程敌人视觉改为 `enemy_spring_cannon.png`。
- 保留移动、距离控制、射击逻辑。

### Projectile.tscn / projectile.gd

- 投射物视觉改为 `projectile_button.png`。
- 投射物朝移动方向旋转。

## 验收标准

1. 运行后场景能看到夜晚修理台背景。
2. 玩家能看出是小修理师/修理精灵。
3. 近战敌人能看出是积木兵。
4. 远程敌人能看出是弹簧炮玩具。
5. 投射物能看出是纽扣。
6. 攻击时能看到木尺/工具挥击资源。
7. 移动、攻击、Dash、受伤、清房、三选一、胜利/失败流程不破坏。
8. 若生成图带棋盘格背景，记录为美术资源问题，不在本轮代码内强行修图。

## 风险

- 部分资源看起来像透明背景，但实际可能带棋盘格底，需要后续重新导出透明 PNG。
- 角色/敌人图为偏正面绘本图，旋转朝向时可能不如专门的俯视角 Sprite 自然。
- 攻击资源是扇形木尺图，与当前矩形判定不完全一致，本轮只作为视觉提示叠加。
