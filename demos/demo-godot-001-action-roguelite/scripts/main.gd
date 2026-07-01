extends Node2D

var player_scene := preload("res://scenes/Player.tscn")
var melee_scene := preload("res://scenes/MeleeEnemy.tscn")
var ranged_scene := preload("res://scenes/RangedEnemy.tscn")
var terrain_tilesheet := preload("res://assets/art/toy_repair_prototype/terrain_tiles/terrain_tilesheet_1024.png")
var BreakableTerrainBodyScript := preload("res://scripts/breakable_terrain_body.gd")
var room_backgrounds := [
	preload("res://assets/art/toy_repair_prototype/bg_repair_table.png"),
	preload("res://assets/art/toy_repair_prototype/bg_repair_table.png"),
	preload("res://assets/art/toy_repair_prototype/bg_repair_table.png")
]
var blessing_pool: Array = []
var current_room := 0
var enemies_alive := 0
var choosing_blessing := false
var offered_blessings: Array = []
var acquired_blessings: Array = []
var player: Node
var damage_flash_tween: Tween
var debug_toggle_down := false
var run_started := false
var run_ended := false
var room_size := Vector2(3168.0, 1344.0)
var room_gap := 320.0
var world_size := Vector2(10144.0, 1344.0)
var play_area_min := Vector2(80.0, 120.0)
var play_area_max := Vector2(3088.0, 1264.0)
var terrain_atlas := {
	"block_center": Rect2(150, 138, 137, 127),
	"toolbox_center": Rect2(7, 432, 191, 173),
	"woodpile_center": Rect2(211, 435, 186, 161),
	"toybox_panel_gold": Rect2(628, 422, 184, 189),
	"rim_highlight": Rect2(614, 643, 207, 37),
	"toolbox_latch": Rect2(63, 665, 76, 100),
	"toolbox_handle": Rect2(235, 687, 141, 63)
}
var terrain_tile_properties := {
	Vector2i(0, 0): {"type": "hard", "footprint": Vector2i(1, 1)},
	Vector2i(1, 0): {"type": "hard", "footprint": Vector2i(1, 1)},
	Vector2i(2, 0): {"type": "hard", "footprint": Vector2i(1, 1)},
	Vector2i(3, 0): {"type": "hard", "footprint": Vector2i(1, 1)},
	Vector2i(0, 1): {"type": "hard", "footprint": Vector2i(3, 1)},
	Vector2i(3, 1): {"type": "hard", "footprint": Vector2i(3, 1)},
	Vector2i(6, 0): {"type": "hard", "footprint": Vector2i(1, 3)},
	Vector2i(0, 2): {"type": "slow", "footprint": Vector2i(1, 1)},
	Vector2i(1, 2): {"type": "slow", "footprint": Vector2i(2, 1)},
	Vector2i(3, 2): {"type": "slow", "footprint": Vector2i(2, 2)},
	Vector2i(5, 2): {"type": "breakable", "footprint": Vector2i(1, 1)},
	Vector2i(6, 3): {"type": "decor", "footprint": Vector2i(1, 1)},
	Vector2i(7, 3): {"type": "decor", "footprint": Vector2i(1, 1)}
}

@onready var room_background := $RepairTableBg
@onready var room_backgrounds_root := $RoomBackgrounds
@onready var room_root := $RoomRoot
@onready var map_root := $MapRoot
@onready var hud_panel := $CanvasLayer/UI/HudPanel
@onready var ui_status := $CanvasLayer/UI/HudPanel/HudList/Status
@onready var ui_message := $CanvasLayer/UI/HudPanel/HudList/Message
@onready var damage_flash := $CanvasLayer/UI/DamageFlash
@onready var acquired_blessings_panel := $CanvasLayer/UI/AcquiredBlessingsPanel
@onready var acquired_blessings_items := $CanvasLayer/UI/AcquiredBlessingsPanel/AcquiredBlessingsList/Items
@onready var debug_panel := $CanvasLayer/UI/DebugPanel
@onready var start_panel := $CanvasLayer/UI/StartPanel
@onready var start_button := $CanvasLayer/UI/StartPanel/StartList/StartButton
@onready var result_panel := $CanvasLayer/UI/ResultPanel
@onready var result_title := $CanvasLayer/UI/ResultPanel/ResultList/Title
@onready var result_blessings := $CanvasLayer/UI/ResultPanel/ResultList/Blessings
@onready var restart_button := $CanvasLayer/UI/ResultPanel/ResultList/RestartButton
@onready var blessing_panel := $CanvasLayer/UI/BlessingPanel
@onready var blessing_buttons := [
	$CanvasLayer/UI/BlessingPanel/BlessingRoot/CardRow/Blessing1,
	$CanvasLayer/UI/BlessingPanel/BlessingRoot/CardRow/Blessing2,
	$CanvasLayer/UI/BlessingPanel/BlessingRoot/CardRow/Blessing3
]
@onready var debug_blessing_buttons := [
	$CanvasLayer/UI/DebugPanel/DebugList/DebugBlessing1,
	$CanvasLayer/UI/DebugPanel/DebugList/DebugBlessing2,
	$CanvasLayer/UI/DebugPanel/DebugList/DebugBlessing3,
	$CanvasLayer/UI/DebugPanel/DebugList/DebugBlessing4,
	$CanvasLayer/UI/DebugPanel/DebugList/DebugBlessing5,
	$CanvasLayer/UI/DebugPanel/DebugList/DebugBlessing6
]

var rooms := [
	[
		{"type": "melee", "pos": Vector2(1180, 520)},
		{"type": "melee", "pos": Vector2(1980, 820)}
	],
	[
		{"type": "melee", "pos": Vector2(1120, 460)},
		{"type": "melee", "pos": Vector2(2040, 820)},
		{"type": "ranged", "pos": Vector2(1580, 360)}
	],
	[
		{"type": "melee_elite", "pos": Vector2(1580, 520)},
		{"type": "ranged", "pos": Vector2(1080, 860)},
		{"type": "ranged", "pos": Vector2(2140, 860)}
	]
]

var room_maps := [
	{
		"obstacles": [
			{"pos": Vector2(1450, 640), "size": Vector2(140, 62), "color": Color(0.52, 0.28, 0.12, 0.92), "kind": "woodpile"},
			{"pos": Vector2(2380, 480), "size": Vector2(260, 72), "color": Color(0.50, 0.18, 0.12, 0.92), "kind": "toolbox"}
		],
		"glue": [
			{"pos": Vector2(1860, 620), "size": Vector2(150, 88)}
		]
	},
	{
		"obstacles": [
			{"pos": Vector2(1380, 610), "size": Vector2(132, 62), "color": Color(0.42, 0.26, 0.62, 0.9), "kind": "block"},
			{"pos": Vector2(1820, 720), "size": Vector2(150, 58), "color": Color(0.52, 0.32, 0.16, 0.92), "kind": "woodpile"},
			{"pos": Vector2(2280, 920), "size": Vector2(320, 64), "color": Color(0.36, 0.23, 0.14, 0.94), "kind": "toybox_edge"}
		],
		"glue": [
			{"pos": Vector2(1580, 860), "size": Vector2(170, 92)}
		]
	},
	{
		"obstacles": [
			{"pos": Vector2(1330, 680), "size": Vector2(138, 58), "color": Color(0.46, 0.28, 0.16, 0.92), "kind": "woodpile"},
			{"pos": Vector2(1820, 600), "size": Vector2(138, 58), "color": Color(0.32, 0.42, 0.58, 0.9), "kind": "block"},
			{"pos": Vector2(1580, 880), "size": Vector2(170, 54), "color": Color(0.55, 0.36, 0.16, 0.9), "kind": "woodpile"},
			{"pos": Vector2(2380, 720), "size": Vector2(280, 78), "color": Color(0.46, 0.16, 0.12, 0.94), "kind": "toolbox"},
			{"pos": Vector2(900, 520), "size": Vector2(300, 64), "color": Color(0.36, 0.23, 0.14, 0.94), "kind": "toybox_edge"}
		],
		"glue": [
			{"pos": Vector2(1180, 840), "size": Vector2(150, 88)},
			{"pos": Vector2(2040, 820), "size": Vector2(150, 88)}
		]
	}
]

func _ready() -> void:
	randomize()
	_load_blessings()
	for i in blessing_buttons.size():
		var button_index := i
		blessing_buttons[i].pressed.connect(func(): _pick_blessing(button_index))
	for i in debug_blessing_buttons.size():
		var button_index := i
		debug_blessing_buttons[i].pressed.connect(func(): _debug_apply_blessing(button_index))
	start_button.pressed.connect(_start_run)
	restart_button.pressed.connect(func(): get_tree().reload_current_scene())
	_setup_ui_style()
	acquired_blessings_panel.visible = false
	debug_panel.visible = false
	blessing_panel.visible = false
	result_panel.visible = false
	start_panel.visible = true
	ui_status.text = ""
	ui_message.text = "1/3 · 等待入夜"
	_show_all_manual_terrain_layers_in_editor()
	_setup_room_backgrounds()
	_apply_render_layers()
	_update_room_background(0)
	_update_debug_buttons()
	_update_acquired_blessings()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	var debug_key_down := Input.is_physical_key_pressed(KEY_QUOTELEFT) or Input.is_key_pressed(KEY_ASCIITILDE)
	if debug_key_down and not debug_toggle_down:
		_toggle_debug_panel()
	debug_toggle_down = debug_key_down
	if choosing_blessing:
		if Input.is_action_just_pressed("pick_blessing_1"):
			_pick_blessing(0)
		elif Input.is_action_just_pressed("pick_blessing_2"):
			_pick_blessing(1)
		elif Input.is_action_just_pressed("pick_blessing_3"):
			_pick_blessing(2)

func _load_blessings() -> void:
	var file := FileAccess.open("res://data/blessings.json", FileAccess.READ)
	if file == null:
		push_error("Missing blessings.json")
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_ARRAY:
		blessing_pool = parsed

func _show_all_manual_terrain_layers_in_editor() -> void:
	if not OS.has_feature("editor"):
		return
	for child in map_root.get_children():
		if _is_manual_terrain_layer(child):
			child.visible = true

func _setup_room_backgrounds() -> void:
	room_background.visible = false
	for room_index in range(rooms.size()):
		var sprite := room_backgrounds_root.get_node_or_null("RoomBackground%d" % [room_index + 1]) as Sprite2D
		if sprite == null:
			sprite = Sprite2D.new()
			sprite.name = "RoomBackground%d" % [room_index + 1]
			room_backgrounds_root.add_child(sprite)
		sprite.texture = room_backgrounds[clampi(room_index, 0, room_backgrounds.size() - 1)]
		sprite.position = _get_room_offset(room_index) + room_size * 0.5
		sprite.z_index = -100

func _get_room_offset(index: int) -> Vector2:
	return Vector2(float(index) * (room_size.x + room_gap), 0.0)

func _get_room_play_area_min(index: int) -> Vector2:
	return _get_room_offset(index) + play_area_min

func _get_room_play_area_max(index: int) -> Vector2:
	return _get_room_offset(index) + play_area_max

func _get_room_local_position(index: int, position: Vector2) -> Vector2:
	return _get_room_offset(index) + position

func _update_player_camera_limits(index: int) -> void:
	if player == null or not player.has_node("Camera2D"):
		return
	var camera := player.get_node("Camera2D") as Camera2D
	var offset := _get_room_offset(index)
	camera.limit_left = int(offset.x)
	camera.limit_top = int(offset.y)
	camera.limit_right = int(offset.x + room_size.x)
	camera.limit_bottom = int(offset.y + room_size.y)
	camera.reset_smoothing()

func _apply_render_layers() -> void:
	room_background.z_index = -100
	room_backgrounds_root.z_index = -100
	map_root.z_index = 0
	room_root.z_index = 100
	for layer in map_root.get_children():
		if _is_manual_terrain_layer(layer):
			layer.z_index = _get_terrain_layer_z(layer)

func _get_terrain_layer_z(layer: Node) -> int:
	if layer.name.begins_with("ManualTerrainUpper"):
		return 200
	return 0

func _update_room_background(index: int) -> void:
	for room_index in range(room_backgrounds_root.get_child_count()):
		var background := room_backgrounds_root.get_child(room_index)
		background.visible = OS.has_feature("editor") or room_index == index

func _start_run() -> void:
	if run_started:
		return
	run_started = true
	run_ended = false
	start_panel.visible = false
	result_panel.visible = false
	player = player_scene.instantiate()
	player.global_position = _get_room_local_position(0, Vector2(1584, 1030))
	add_child(player)
	player.died.connect(_on_player_died)
	player.damaged.connect(_on_player_damaged)
	player.health_changed.connect(_on_player_health_changed)
	current_room = 0
	_spawn_room(current_room)
	ui_message.text = "1/%d · 修理中" % rooms.size()
	blessing_panel.visible = false

func _spawn_room(index: int) -> void:
	for child in room_root.get_children():
		child.queue_free()
	_spawn_room_map(index)
	_update_room_background(index)
	if player != null:
		player.play_area_min = _get_room_play_area_min(index)
		player.play_area_max = _get_room_play_area_max(index)
		player.global_position = _get_room_local_position(index, Vector2(1584, 1030))
		_update_player_camera_limits(index)
	enemies_alive = 0
	var room = rooms[index]
	for enemy_data in room:
		var enemy: Node
		match enemy_data["type"]:
			"melee":
				enemy = melee_scene.instantiate()
			"melee_elite":
				enemy = melee_scene.instantiate()
				enemy.elite = true
			"ranged":
				enemy = ranged_scene.instantiate()
		enemy.global_position = _get_room_local_position(index, enemy_data["pos"])
		enemy.player = player
		enemy.died.connect(_on_enemy_died)
		room_root.add_child(enemy)
		enemy.add_to_group("enemies")
		enemies_alive += 1
	_update_status()

func _spawn_room_map(index: int) -> void:
	for child in map_root.get_children():
		if not _is_manual_terrain_layer(child):
			child.queue_free()
	_update_manual_terrain_layers(index)
	_create_boundary_hint(index)
	var terrain_rects := _spawn_tilemap_terrain(index)
	_create_navigation_region(terrain_rects, index)

func _is_manual_terrain_layer(node: Node) -> bool:
	return node.name.begins_with("ManualTerrainRoom") or node.name.begins_with("ManualTerrainUpper")

func _is_room_terrain_layer(node: Node, index: int) -> bool:
	return node.name == "ManualTerrainRoom%d" % [index + 1] or node.name == "ManualTerrainUpperRoom%d" % [index + 1]

func _update_manual_terrain_layers(index: int) -> void:
	for child in map_root.get_children():
		if _is_manual_terrain_layer(child):
			child.visible = _is_room_terrain_layer(child, index)

func _create_boundary_hint(index: int) -> void:
	var root := Node2D.new()
	root.name = "BoundaryHint"
	var offset := _get_room_offset(index)
	var min_area := _get_room_play_area_min(index)
	var max_area := _get_room_play_area_max(index)
	var shade := Color(0.05, 0.025, 0.01, 0.24)
	var line := Color(0.8, 0.55, 0.28, 0.36)
	_add_boundary_rect(root, offset, Vector2(room_size.x, play_area_min.y), shade)
	_add_boundary_rect(root, offset + Vector2(0.0, play_area_max.y), Vector2(room_size.x, room_size.y - play_area_max.y), shade)
	_add_boundary_rect(root, offset, Vector2(play_area_min.x, room_size.y), shade)
	_add_boundary_rect(root, offset + Vector2(play_area_max.x, 0.0), Vector2(room_size.x - play_area_max.x, room_size.y), shade)
	_add_boundary_rect(root, min_area, Vector2(max_area.x - min_area.x, 3.0), line)
	_add_boundary_rect(root, Vector2(min_area.x, max_area.y - 3.0), Vector2(max_area.x - min_area.x, 3.0), line)
	_add_boundary_rect(root, min_area, Vector2(3.0, max_area.y - min_area.y), line)
	_add_boundary_rect(root, Vector2(max_area.x - 3.0, min_area.y), Vector2(3.0, max_area.y - min_area.y), line)
	map_root.add_child(root)

func _add_boundary_rect(root: Node, position: Vector2, size: Vector2, color: Color) -> void:
	var rect := ColorRect.new()
	rect.position = position
	rect.size = size
	rect.color = color
	root.add_child(rect)

func _create_navigation_region(blocking_rects: Array, index: int) -> void:
	var region := NavigationRegion2D.new()
	region.name = "NavigationRegion2D"
	var offset := _get_room_offset(index)
	var polygon := NavigationPolygon.new()
	polygon.add_outline(PackedVector2Array([
		offset + Vector2(120, 220),
		offset + Vector2(3048, 220),
		offset + Vector2(3048, 1230),
		offset + Vector2(120, 1230)
	]))
	for rect_data in blocking_rects:
		var position: Vector2 = rect_data["pos"]
		var size: Vector2 = rect_data["size"] + Vector2(96, 96)
		var half := size * 0.5
		polygon.add_outline(PackedVector2Array([
			position + Vector2(-half.x, -half.y),
			position + Vector2(half.x, -half.y),
			position + Vector2(half.x, half.y),
			position + Vector2(-half.x, half.y)
		]))
	polygon.make_polygons_from_outlines()
	region.navigation_polygon = polygon
	map_root.add_child(region)

func _spawn_tilemap_terrain(index: int) -> Array:
	var hard_cells: Array[Vector2i] = []
	var layer := map_root.get_node_or_null("ManualTerrainRoom%d" % [index + 1]) as TileMapLayer
	if layer == null:
		return []
	for cell in layer.get_used_cells():
		var atlas_coords := layer.get_cell_atlas_coords(cell)
		var properties: Dictionary = terrain_tile_properties.get(atlas_coords, {"type": "decor", "footprint": Vector2i(1, 1)})
		var footprint: Vector2i = properties.get("footprint", Vector2i(1, 1))
		match String(properties.get("type", "decor")):
			"hard":
				_create_tile_terrain_body(layer, cell, footprint)
				for footprint_cell in _get_terrain_footprint_cells(cell, footprint):
					hard_cells.append(footprint_cell)
			"breakable":
				_create_tile_breakable_body(layer, cell, footprint)
				for footprint_cell in _get_terrain_footprint_cells(cell, footprint):
					hard_cells.append(footprint_cell)
			"slow":
				_create_tile_slow_area(layer, cell, footprint)
	return _make_tile_blocking_rects(layer, hard_cells)

func _get_terrain_footprint_cells(origin_cell: Vector2i, footprint: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for y in range(maxi(footprint.y, 1)):
		for x in range(maxi(footprint.x, 1)):
			cells.append(origin_cell + Vector2i(x, y))
	return cells

func _make_tile_blocking_rects(layer: TileMapLayer, hard_cells: Array[Vector2i]) -> Array:
	var blocking_rects := []
	var remaining := {}
	for cell in hard_cells:
		remaining[cell] = true
	while not remaining.is_empty():
		var start: Vector2i = remaining.keys()[0]
		remaining.erase(start)
		var queue: Array[Vector2i] = [start]
		var component: Array[Vector2i] = []
		while not queue.is_empty():
			var cell: Vector2i = queue.pop_back()
			component.append(cell)
			var offsets: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
			for offset in offsets:
				var next: Vector2i = cell + offset
				if remaining.has(next):
					remaining.erase(next)
					queue.append(next)
		blocking_rects.append(_make_component_blocking_rect(layer, component))
	return blocking_rects

func _make_component_blocking_rect(layer: TileMapLayer, cells: Array[Vector2i]) -> Dictionary:
	var min_cell := cells[0]
	var max_cell := cells[0]
	for cell in cells:
		min_cell.x = mini(min_cell.x, cell.x)
		min_cell.y = mini(min_cell.y, cell.y)
		max_cell.x = maxi(max_cell.x, cell.x)
		max_cell.y = maxi(max_cell.y, cell.y)
	var min_pos := layer.to_global(layer.map_to_local(min_cell)) - Vector2(32.0, 32.0)
	var max_pos := layer.to_global(layer.map_to_local(max_cell)) + Vector2(32.0, 32.0)
	return {"pos": (min_pos + max_pos) * 0.5, "size": max_pos - min_pos}

func _create_tile_terrain_body(layer: TileMapLayer, cell: Vector2i, footprint: Vector2i) -> Dictionary:
	var body := StaticBody2D.new()
	body.name = "TileTerrainBody"
	body.collision_layer = 8
	body.collision_mask = 3
	var size := Vector2(maxi(footprint.x, 1), maxi(footprint.y, 1)) * 64.0
	body.global_position = layer.to_global(layer.map_to_local(cell)) + (size - Vector2(64.0, 64.0)) * 0.5
	body.add_to_group("obstacles")
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.add_child(shape)
	map_root.add_child(body)
	return {"pos": body.global_position, "size": rect.size}

func _create_tile_breakable_body(layer: TileMapLayer, cell: Vector2i, footprint: Vector2i) -> Dictionary:
	var body := StaticBody2D.new()
	body.name = "BreakableTerrainBody"
	body.collision_layer = 8
	body.collision_mask = 3
	body.set_meta("hp", 20)
	var size := Vector2(maxi(footprint.x, 1), maxi(footprint.y, 1)) * 64.0
	body.global_position = layer.to_global(layer.map_to_local(cell)) + (size - Vector2(64.0, 64.0)) * 0.5
	body.add_to_group("obstacles")
	body.set_meta("tile_layer_path", layer.get_path())
	body.set_meta("tile_origin_cell", cell)
	body.set_meta("tile_footprint", footprint)
	body.set_script(BreakableTerrainBodyScript)
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.add_child(shape)
	map_root.add_child(body)
	return {"pos": body.global_position, "size": rect.size}

func _create_tile_slow_area(layer: TileMapLayer, cell: Vector2i, footprint: Vector2i) -> void:
	var size := Vector2(maxi(footprint.x, 1), maxi(footprint.y, 1)) * 64.0
	var center := layer.to_global(layer.map_to_local(cell)) + (size - Vector2(64.0, 64.0)) * 0.5
	_create_glue_puddle({"pos": center, "size": size})

func _create_obstacle(data: Dictionary) -> void:
	if not data.get("blocks", true):
		_create_manual_terrain(data)
		return
	var body := StaticBody2D.new()
	body.name = "Obstacle"
	body.collision_layer = 8
	body.collision_mask = 3
	body.global_position = data["pos"]
	body.add_to_group("obstacles")
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = data["size"]
	shape.shape = rect
	body.add_child(shape)
	_add_obstacle_sprite(body, data)
	map_root.add_child(body)

func _create_manual_terrain(data: Dictionary) -> void:
	var root := Node2D.new()
	root.name = "ManualTerrain"
	root.global_position = data["pos"]
	_add_obstacle_sprite(root, data)
	map_root.add_child(root)

func _add_obstacle_sprite(body: Node2D, data: Dictionary) -> void:
	var atlas_key := _get_obstacle_atlas_key(data)
	var size: Vector2 = data["size"]
	var sprite := _make_atlas_sprite(atlas_key, size)
	body.add_child(sprite)
	var kind := String(data.get("kind", "block"))
	match kind:
		"toolbox":
			var latch := _make_atlas_sprite("toolbox_latch", Vector2(36.0, 44.0))
			latch.position = Vector2(-size.x * 0.22, 0.0)
			body.add_child(latch)
			var handle := _make_atlas_sprite("toolbox_handle", Vector2(62.0, 28.0))
			handle.position = Vector2(size.x * 0.14, -size.y * 0.03)
			body.add_child(handle)
		"toybox_edge":
			var rim := _make_atlas_sprite("rim_highlight", Vector2(size.x * 0.82, 16.0))
			rim.position = Vector2(0.0, -size.y * 0.18)
			body.add_child(rim)

func _get_obstacle_atlas_key(data: Dictionary) -> String:
	if data.has("atlas"):
		return String(data["atlas"])
	match String(data.get("kind", "block")):
		"toolbox":
			return "toolbox_center"
		"woodpile":
			return "woodpile_center"
		"toybox_edge":
			return "toybox_panel_gold"
	return "block_center"

func _make_atlas_sprite(atlas_key: String, target_size: Vector2) -> Sprite2D:
	var rect: Rect2 = terrain_atlas[atlas_key]
	var sprite := Sprite2D.new()
	sprite.texture = terrain_tilesheet
	sprite.region_enabled = true
	sprite.region_rect = rect
	sprite.scale = Vector2(target_size.x / rect.size.x, target_size.y / rect.size.y)
	return sprite

func _create_glue_puddle(data: Dictionary) -> void:
	var area := Area2D.new()
	area.name = "GluePuddle"
	area.collision_layer = 0
	area.collision_mask = 1
	area.global_position = data["pos"]
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = data["size"]
	shape.shape = rect
	area.add_child(shape)
	var visual := ColorRect.new()
	visual.color = Color(0.95, 0.72, 0.22, 0.28)
	visual.size = data["size"]
	visual.position = -data["size"] * 0.5
	area.add_child(visual)
	area.body_entered.connect(func(body: Node2D):
		if body.has_method("set_slow_multiplier"):
			body.set_slow_multiplier(0.65)
	)
	area.body_exited.connect(func(body: Node2D):
		if body.has_method("set_slow_multiplier"):
			body.set_slow_multiplier(1.0)
	)
	map_root.add_child(area)

func _on_enemy_died(_enemy: Node) -> void:
	if run_ended:
		return
	enemies_alive -= 1
	_update_status()
	if enemies_alive <= 0:
		_on_room_cleared()

func _on_room_cleared() -> void:
	if current_room >= rooms.size() - 1:
		_show_result(true)
		return
	choosing_blessing = true
	offered_blessings = _roll_blessings(3)
	for i in offered_blessings.size():
		var blessing: Dictionary = offered_blessings[i]
		blessing_buttons[i].text = _format_blessing_card(blessing, i)
		_style_button(blessing_buttons[i], true)
	blessing_panel.visible = true
	ui_message.text = "选择一个修理灵感"

func _roll_blessings(count: int) -> Array:
	var pool := blessing_pool.duplicate()
	pool.shuffle()
	return pool.slice(0, min(count, pool.size()))

func _pick_blessing(index: int) -> void:
	if not choosing_blessing or index >= offered_blessings.size():
		return
	var blessing: Dictionary = offered_blessings[index]
	_apply_blessing(blessing, false)
	choosing_blessing = false
	blessing_panel.visible = false
	current_room += 1
	ui_message.text = "%d/%d · 修理中" % [current_room + 1, rooms.size()]
	_spawn_room(current_room)

func _toggle_debug_panel() -> void:
	var next_visible: bool = not debug_panel.visible
	acquired_blessings_panel.visible = next_visible
	debug_panel.visible = next_visible

func _debug_apply_blessing(index: int) -> void:
	if index < blessing_pool.size() and run_started and not run_ended:
		_apply_blessing(blessing_pool[index], true)

func _apply_blessing(blessing: Dictionary, debug := false) -> void:
	if player == null:
		return
	player.apply_blessing(blessing)
	acquired_blessings.append(blessing)
	_update_acquired_blessings()
	if debug:
		ui_message.text = "调试添加修理灵感：%s" % blessing["name"]

func _update_debug_buttons() -> void:
	for i in debug_blessing_buttons.size():
		if i < blessing_pool.size():
			debug_blessing_buttons[i].text = blessing_pool[i]["name"]
		else:
			debug_blessing_buttons[i].disabled = true

func _update_acquired_blessings() -> void:
	if acquired_blessings.is_empty():
		acquired_blessings_items.text = "暂无"
		return
	var lines: Array[String] = []
	for blessing in acquired_blessings:
		lines.append("- %s" % blessing["name"])
	acquired_blessings_items.text = "\n".join(lines)

func _show_result(victory: bool) -> void:
	run_ended = true
	choosing_blessing = false
	blessing_panel.visible = false
	result_title.text = "黎明前修好了所有玩具" if victory else "小灯熄灭了"
	result_blessings.text = _format_result_blessings()
	result_panel.visible = true
	ui_message.text = "完成" if victory else "熄灭"

func _format_result_blessings() -> String:
	if acquired_blessings.is_empty():
		return "本晚灵感：暂无"
	var lines: Array[String] = ["本晚灵感："]
	for blessing in acquired_blessings:
		lines.append("- %s" % blessing["name"])
	return "\n".join(lines)

func _setup_ui_style() -> void:
	var panel_style := _make_panel_style(Color(0.105, 0.058, 0.033, 0.82), Color(0.84, 0.58, 0.30, 0.95), 14, 3)
	var hud_style := _make_panel_style(Color(0.045, 0.035, 0.030, 0.55), Color(0.88, 0.72, 0.48, 0.62), 999, 1)
	var side_style := _make_panel_style(Color(0.08, 0.05, 0.035, 0.72), Color(0.42, 0.64, 0.74, 0.8), 8, 2)
	var debug_style := _make_panel_style(Color(0.05, 0.05, 0.06, 0.78), Color(0.55, 0.55, 0.6, 0.7), 6, 2)
	for panel in [start_panel, blessing_panel, result_panel]:
		panel.add_theme_stylebox_override("panel", panel_style)
	hud_panel.add_theme_stylebox_override("panel", hud_style)
	for panel in [acquired_blessings_panel]:
		panel.add_theme_stylebox_override("panel", side_style)
	debug_panel.add_theme_stylebox_override("panel", debug_style)
	_style_label(ui_status, 22, Color(1.0, 0.16, 0.13))
	_style_label(ui_message, 14, Color(0.95, 0.84, 0.66))
	_style_label($CanvasLayer/UI/ControlsHint, 14, Color(0.92, 0.82, 0.68, 0.52))
	_style_button(start_button, false)
	_style_button(restart_button, false)
	for button in blessing_buttons:
		_style_button(button, true)
	for button in debug_blessing_buttons:
		_style_button(button, false)
	_style_panel_labels(start_panel)
	_style_panel_labels(blessing_panel)
	_style_panel_labels(result_panel)
	_style_panel_labels(acquired_blessings_panel)
	_style_panel_labels(debug_panel)
	_style_label($CanvasLayer/UI/StartPanel/StartList/Title, 52, Color(1.0, 0.92, 0.68))
	_style_label($CanvasLayer/UI/StartPanel/StartList/Subtitle, 21, Color(0.96, 0.82, 0.62))
	_style_label($CanvasLayer/UI/StartPanel/StartList/Controls, 16, Color(0.84, 0.74, 0.62))
	_style_label($CanvasLayer/UI/BlessingPanel/BlessingRoot/Title, 34, Color(1.0, 0.9, 0.66))
	_style_label($CanvasLayer/UI/ResultPanel/ResultList/Title, 38, Color(1.0, 0.9, 0.66))
	start_panel.custom_minimum_size = Vector2(640, 390)
	blessing_panel.custom_minimum_size = Vector2(980, 440)
	result_panel.custom_minimum_size = Vector2(500, 300)
	$CanvasLayer/UI/StartPanel/StartList.add_theme_constant_override("separation", 18)
	$CanvasLayer/UI/BlessingPanel/BlessingRoot.add_theme_constant_override("separation", 18)
	$CanvasLayer/UI/ResultPanel/ResultList.add_theme_constant_override("separation", 16)
	$CanvasLayer/UI/BlessingPanel/BlessingRoot/Title.text = "修理灵感 · 选择今晚的工具"
	$CanvasLayer/UI/StartPanel/StartList/Subtitle.text = "◇ 让破损玩具重新发光 ◇"

func _make_panel_style(fill: Color, border: Color, radius: int, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.46)
	style.shadow_size = 14
	return style

func _make_button_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	style.shadow_size = 8
	return style

func _style_button(button: Button, card := false) -> void:
	var normal := _make_button_style(Color(0.38, 0.20, 0.10, 0.94), Color(0.90, 0.64, 0.34, 0.95))
	var hover := _make_button_style(Color(0.55, 0.32, 0.15, 0.98), Color(1.0, 0.84, 0.48, 1.0))
	var pressed := _make_button_style(Color(0.24, 0.13, 0.07, 1.0), Color(1.0, 0.86, 0.52, 1.0))
	if card:
		normal = _make_button_style(Color(0.125, 0.075, 0.048, 0.97), Color(0.86, 0.58, 0.30, 0.95))
		hover = _make_button_style(Color(0.24, 0.145, 0.085, 0.99), Color(1.0, 0.82, 0.44, 1.0))
		pressed = _make_button_style(Color(0.10, 0.065, 0.045, 1.0), Color(1.0, 0.90, 0.58, 1.0))
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_color_override("font_color", Color(0.98, 0.9, 0.72))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.96, 0.80))
	button.add_theme_font_size_override("font_size", 17 if card else 17)
	button.add_theme_constant_override("outline_size", 2 if card else 1)
	button.add_theme_color_override("font_outline_color", Color(0.05, 0.025, 0.015, 0.88))

func _style_label(label: Label, size: int, color: Color) -> void:
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.75))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.add_theme_font_size_override("font_size", size)

func _style_panel_labels(root_node: Node) -> void:
	for child in root_node.find_children("*", "Label", true, false):
		var label := child as Label
		_style_label(label, 18, Color(0.96, 0.86, 0.66))

func _format_tags(blessing: Dictionary) -> String:
	var tags: Array = blessing.get("tags", [])
	return " / ".join(tags) if not tags.is_empty() else "通用"

func _format_blessing_card(blessing: Dictionary, index: int) -> String:
	var tags_text := _format_tags(blessing)
	return "NO.%02d\n[%s]\n%s\n\n%s\n\n按 %d 选择" % [index + 1, tags_text, blessing["name"], blessing["description"], index + 1]

func _on_player_died() -> void:
	_show_result(false)

func _on_player_damaged() -> void:
	if damage_flash_tween != null:
		damage_flash_tween.kill()
	damage_flash.color = Color(1.0, 0.0, 0.0, 0.28)
	damage_flash_tween = create_tween()
	damage_flash_tween.tween_property(damage_flash, "color", Color(1.0, 0.0, 0.0, 0.0), 0.22)

func _on_player_health_changed(current: int, maximum: int) -> void:
	ui_status.text = "♥ %d" % current
	ui_message.text = "%d/%d · %d" % [current_room + 1, rooms.size(), enemies_alive]

func _update_status() -> void:
	if player != null:
		ui_status.text = "♥ %d" % player.hp
		ui_message.text = "%d/%d · %d" % [current_room + 1, rooms.size(), enemies_alive]
