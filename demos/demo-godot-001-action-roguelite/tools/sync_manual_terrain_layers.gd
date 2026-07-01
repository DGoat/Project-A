extends SceneTree

const SCENE_PATH := "res://scenes/Main.tscn"
const CELL_SIZE := 64.0

var room_obstacles := [
	[
		{"pos": Vector2(1450, 640), "size": Vector2(140, 62), "tile": Vector2i(2, 0)},
		{"pos": Vector2(2380, 480), "size": Vector2(260, 72), "tile": Vector2i(1, 0)}
	],
	[
		{"pos": Vector2(1380, 610), "size": Vector2(132, 62), "tile": Vector2i(0, 0)},
		{"pos": Vector2(1820, 720), "size": Vector2(150, 58), "tile": Vector2i(2, 0)},
		{"pos": Vector2(2280, 920), "size": Vector2(320, 64), "tile": Vector2i(3, 0)}
	],
	[
		{"pos": Vector2(1330, 680), "size": Vector2(138, 58), "tile": Vector2i(2, 0)},
		{"pos": Vector2(1820, 600), "size": Vector2(138, 58), "tile": Vector2i(0, 0)},
		{"pos": Vector2(1580, 880), "size": Vector2(170, 54), "tile": Vector2i(2, 0)},
		{"pos": Vector2(2380, 720), "size": Vector2(280, 78), "tile": Vector2i(1, 0)},
		{"pos": Vector2(900, 520), "size": Vector2(300, 64), "tile": Vector2i(3, 0)}
	]
]

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var packed := load(SCENE_PATH) as PackedScene
	var scene := packed.instantiate()
	root.add_child(scene)
	for room_index in range(room_obstacles.size()):
		var layer := scene.get_node("MapRoot/ManualTerrainRoom%d" % [room_index + 1]) as TileMapLayer
		layer.clear()
		for item in room_obstacles[room_index]:
			_paint_obstacle(layer, item["pos"], item["size"], item["tile"])
		layer.visible = true
	var saved := PackedScene.new()
	saved.pack(scene)
	ResourceSaver.save(saved, SCENE_PATH)
	quit()

func _paint_obstacle(layer: TileMapLayer, center: Vector2, size: Vector2, tile: Vector2i) -> void:
	var min_cell := Vector2i(floori((center.x - size.x * 0.5) / CELL_SIZE), floori((center.y - size.y * 0.5) / CELL_SIZE))
	var max_cell := Vector2i(floori((center.x + size.x * 0.5) / CELL_SIZE), floori((center.y + size.y * 0.5) / CELL_SIZE))
	for y in range(min_cell.y, max_cell.y + 1):
		for x in range(min_cell.x, max_cell.x + 1):
			layer.set_cell(Vector2i(x, y), 0, tile, 0)
