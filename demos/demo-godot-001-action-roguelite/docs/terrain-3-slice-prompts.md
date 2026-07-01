# 三段式地形资源 Prompt（中英对照）

## 通用要求

中文：

```text
生成用于 2D 顶视、轻微俯视视角游戏的三段式地形 tile。每个 tile 是 64x64 px，透明背景 PNG。风格是童话治愈、玩具修理屋、手绘绘本、暖色、柔和圆角。资源用于 TileMap 网格摆放。每个 tile 必须严格在自己的 64x64 区域内，不要越界，不要文字，不要角色，不要背景，不要强投影。left、mid、right 三张必须属于同一材质，边缘能自然连接。mid 必须能横向无缝重复。光照尽量均匀，旋转 90 度后仍尽量可用。
```

English:

```text
Create 3-slice terrain tiles for a 2D top-down with a slight three-quarter angle game. Each tile is a 64x64 px transparent PNG. Cozy fairy-tale toy repair workshop style, hand-painted storybook look, warm colors, soft rounded edges. The assets are for TileMap grid placement. Each tile must stay strictly inside its own 64x64 area, no overflow, no text, no characters, no background, no strong cast shadow. The left, mid, and right tiles must use the same material and connect naturally at their edges. The mid tile must repeat seamlessly horizontally. Lighting should be mostly even so the tiles remain usable after 90-degree rotation.
```

---

## 工具盒边缘：`terrain_toolbox_left/mid/right.png`

中文：

```text
生成一组三段式工具盒边缘 tile：terrain_toolbox_left.png、terrain_toolbox_mid.png、terrain_toolbox_right.png。每张 64x64 px，透明背景。材质为红棕色上漆木头，带轻微旧漆磨损和手绘笔触。left 是圆润左端，mid 是可横向无缝重复的中段，right 是圆润右端。不要锁扣、把手、文字、角色、背景。不要强方向投影。
```

English:

```text
Create a 3-slice toolbox edge tile set: terrain_toolbox_left.png, terrain_toolbox_mid.png, terrain_toolbox_right.png. Each tile is 64x64 px with transparent background. Material is red-brown varnished wood with subtle worn paint and hand-painted brush texture. The left tile is a rounded left cap, the mid tile is a horizontally seamless repeat segment, and the right tile is a rounded right cap. No latch, no handle, no text, no characters, no background. No strong directional shadow.
```

## 木板堆：`terrain_woodpile_left/mid/right.png`

中文：

```text
生成一组三段式木板堆 tile：terrain_woodpile_left.png、terrain_woodpile_mid.png、terrain_woodpile_right.png。每张 64x64 px，透明背景。材质为暖色天然木板，有轻微木纹和手绘线条。left 是木板堆左端，mid 是可横向无缝重复的堆叠木板中段，right 是木板堆右端。三张拼接后像一条连续木板堆。不要文字、角色、背景，不要强投影。
```

English:

```text
Create a 3-slice woodpile tile set: terrain_woodpile_left.png, terrain_woodpile_mid.png, terrain_woodpile_right.png. Each tile is 64x64 px with transparent background. Material is warm natural wooden planks with subtle wood grain and hand-painted linework. The left tile is the left end of the pile, the mid tile is a horizontally seamless repeat segment of stacked planks, and the right tile is the right end. When connected, the three tiles should form one continuous pile of wooden planks. No text, no characters, no background, no strong cast shadow.
```

## 玩具箱边缘：`terrain_toybox_edge_left/mid/right.png`

中文：

```text
生成一组三段式玩具箱边缘 tile：terrain_toybox_edge_left.png、terrain_toybox_edge_mid.png、terrain_toybox_edge_right.png。每张 64x64 px，透明背景。材质为蜂蜜棕色上漆木头，边缘圆润，有柔和高光。left 是左端，mid 是可横向无缝重复的箱沿中段，right 是右端。拼接后像一条连续玩具箱箱沿。不要文字、角色、背景，不要强方向投影。
```

English:

```text
Create a 3-slice toy-box rim tile set: terrain_toybox_edge_left.png, terrain_toybox_edge_mid.png, terrain_toybox_edge_right.png. Each tile is 64x64 px with transparent background. Material is honey-brown varnished wood, rounded edges, soft highlights. The left tile is the left cap, the mid tile is a horizontally seamless repeat segment of the toy-box rim, and the right tile is the right cap. Connected tiles should form one continuous toy-box rim. No text, no characters, no background, no strong directional shadow.
```

## 胶水条：`terrain_glue_strip_left/mid/right.png`

中文：

```text
生成一组三段式胶水条 tile：terrain_glue_strip_left.png、terrain_glue_strip_mid.png、terrain_glue_strip_right.png。每张 64x64 px，透明背景。表现半透明金黄色胶水/蜂蜜质感，边缘柔软、轻微流动感。left 是胶水左端，mid 是可横向无缝重复的胶水中段，right 是胶水右端。胶水要清楚但不要太亮，不要文字、角色、背景，不要强投影。
```

English:

```text
Create a 3-slice glue strip tile set: terrain_glue_strip_left.png, terrain_glue_strip_mid.png, terrain_glue_strip_right.png. Each tile is 64x64 px with transparent background. The material looks like semi-transparent golden glue or honey, with soft edges and a slight flowing feel. The left tile is the left end of the glue strip, the mid tile is a horizontally seamless repeat segment, and the right tile is the right end. The glue should be readable but not too bright. No text, no characters, no background, no strong cast shadow.
```

## 布片边：`terrain_cloth_strip_left/mid/right.png`

中文：

```text
生成一组三段式布片边 tile：terrain_cloth_strip_left.png、terrain_cloth_strip_mid.png、terrain_cloth_strip_right.png。每张 64x64 px，透明背景。表现柔软布片或缝补布条，暖色织物纹理，边缘略不规则但不能越界。left 是布条左端，mid 是可横向无缝重复的布条中段，right 是布条右端。不要文字、角色、背景，不要强投影。
```

English:

```text
Create a 3-slice cloth strip tile set: terrain_cloth_strip_left.png, terrain_cloth_strip_mid.png, terrain_cloth_strip_right.png. Each tile is 64x64 px with transparent background. It should look like a soft fabric strip or patch, warm cloth texture, slightly irregular edges without overflowing the cell. The left tile is the left end, the mid tile is a horizontally seamless repeat segment, and the right tile is the right end. No text, no characters, no background, no strong cast shadow.
```

## 玩具轨道：`terrain_track_left/mid/right.png`

中文：

```text
生成一组三段式玩具轨道 tile：terrain_track_left.png、terrain_track_mid.png、terrain_track_right.png。每张 64x64 px，透明背景。表现小型木质或黄铜玩具轨道，线条清晰，适合引导敌人或投射物路径。left 是轨道左端，mid 是可横向无缝重复的轨道中段，right 是轨道右端。不要文字、角色、背景，不要强投影。
```

English:

```text
Create a 3-slice toy track tile set: terrain_track_left.png, terrain_track_mid.png, terrain_track_right.png. Each tile is 64x64 px with transparent background. It should look like a small wooden or brass toy track, with a clear readable line, suitable for guiding enemies or projectiles. The left tile is the left end, the mid tile is a horizontally seamless repeat segment, and the right tile is the right end. No text, no characters, no background, no strong cast shadow.
```
