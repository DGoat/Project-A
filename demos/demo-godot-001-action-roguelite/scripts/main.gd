extends Node2D

var player_scene := preload("res://scenes/Player.tscn")
var melee_scene := preload("res://scenes/MeleeEnemy.tscn")
var ranged_scene := preload("res://scenes/RangedEnemy.tscn")
var blessing_pool: Array = []
var current_room := 0
var enemies_alive := 0
var choosing_blessing := false
var offered_blessings: Array = []
var acquired_blessings: Array = []
var player: Node
var damage_flash_tween: Tween

@onready var room_root := $RoomRoot
@onready var ui_status := $CanvasLayer/UI/Status
@onready var ui_message := $CanvasLayer/UI/Message
@onready var damage_flash := $CanvasLayer/UI/DamageFlash
@onready var acquired_blessings_items := $CanvasLayer/UI/AcquiredBlessingsPanel/AcquiredBlessingsList/Items
@onready var debug_toggle := $CanvasLayer/UI/DebugToggle
@onready var debug_panel := $CanvasLayer/UI/DebugPanel
@onready var blessing_panel := $CanvasLayer/UI/BlessingPanel
@onready var blessing_buttons := [
	$CanvasLayer/UI/BlessingPanel/BlessingList/Blessing1,
	$CanvasLayer/UI/BlessingPanel/BlessingList/Blessing2,
	$CanvasLayer/UI/BlessingPanel/BlessingList/Blessing3
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
		{"type": "melee", "pos": Vector2(300, 220)},
		{"type": "melee", "pos": Vector2(720, 420)}
	],
	[
		{"type": "melee", "pos": Vector2(260, 220)},
		{"type": "melee", "pos": Vector2(760, 420)},
		{"type": "ranged", "pos": Vector2(520, 160)}
	],
	[
		{"type": "melee_elite", "pos": Vector2(520, 260)},
		{"type": "ranged", "pos": Vector2(260, 430)},
		{"type": "ranged", "pos": Vector2(780, 430)}
	]
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
	debug_toggle.pressed.connect(_toggle_debug_panel)
	_update_debug_buttons()
	_update_acquired_blessings()
	_start_run()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
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

func _start_run() -> void:
	player = player_scene.instantiate()
	player.global_position = Vector2(520, 520)
	add_child(player)
	player.died.connect(_on_player_died)
	player.damaged.connect(_on_player_damaged)
	player.health_changed.connect(_on_player_health_changed)
	current_room = 0
	_spawn_room(current_room)
	ui_message.text = "房间 1：清理敌人"
	blessing_panel.visible = false

func _spawn_room(index: int) -> void:
	for child in room_root.get_children():
		child.queue_free()
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
		enemy.global_position = enemy_data["pos"]
		enemy.player = player
		enemy.died.connect(_on_enemy_died)
		room_root.add_child(enemy)
		enemies_alive += 1
	_update_status()

func _on_enemy_died(_enemy: Node) -> void:
	enemies_alive -= 1
	_update_status()
	if enemies_alive <= 0:
		_on_room_cleared()

func _on_room_cleared() -> void:
	if current_room >= rooms.size() - 1:
		ui_message.text = "胜利！按 R 重开。"
		return
	choosing_blessing = true
	offered_blessings = _roll_blessings(3)
	for i in offered_blessings.size():
		var blessing: Dictionary = offered_blessings[i]
		blessing_buttons[i].text = "%d. %s\n%s" % [i + 1, blessing["name"], blessing["description"]]
	blessing_panel.visible = true
	ui_message.text = "选择一个赐福"

func _roll_blessings(count: int) -> Array:
	var pool := blessing_pool.duplicate()
	pool.shuffle()
	return pool.slice(0, min(count, pool.size()))

func _pick_blessing(index: int) -> void:
	if not choosing_blessing or index >= offered_blessings.size():
		return
	_apply_blessing(offered_blessings[index], false)
	choosing_blessing = false
	blessing_panel.visible = false
	current_room += 1
	ui_message.text = "房间 %d：清理敌人" % [current_room + 1]
	_spawn_room(current_room)

func _toggle_debug_panel() -> void:
	debug_panel.visible = not debug_panel.visible

func _debug_apply_blessing(index: int) -> void:
	if index < blessing_pool.size():
		_apply_blessing(blessing_pool[index], true)

func _apply_blessing(blessing: Dictionary, debug := false) -> void:
	if player == null:
		return
	player.apply_blessing(blessing)
	acquired_blessings.append(blessing)
	_update_acquired_blessings()
	if debug:
		ui_message.text = "调试添加赐福：%s" % blessing["name"]

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

func _on_player_died() -> void:
	ui_message.text = "失败。按 R 重开。"

func _on_player_damaged() -> void:
	if damage_flash_tween != null:
		damage_flash_tween.kill()
	damage_flash.color = Color(1.0, 0.0, 0.0, 0.28)
	damage_flash_tween = create_tween()
	damage_flash_tween.tween_property(damage_flash, "color", Color(1.0, 0.0, 0.0, 0.0), 0.22)

func _on_player_health_changed(current: int, maximum: int) -> void:
	ui_status.text = "HP: %d/%d | 房间: %d/%d | 敌人: %d" % [current, maximum, current_room + 1, rooms.size(), enemies_alive]

func _update_status() -> void:
	if player != null:
		ui_status.text = "HP: %d/%d | 房间: %d/%d | 敌人: %d" % [player.hp, player.max_hp, current_room + 1, rooms.size(), enemies_alive]
