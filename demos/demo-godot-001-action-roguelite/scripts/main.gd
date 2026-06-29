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
var debug_toggle_down := false
var run_started := false
var run_ended := false

@onready var room_root := $RoomRoot
@onready var ui_status := $CanvasLayer/UI/Status
@onready var ui_message := $CanvasLayer/UI/Message
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
	ui_message.text = "等待入夜"
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

func _start_run() -> void:
	if run_started:
		return
	run_started = true
	run_ended = false
	start_panel.visible = false
	result_panel.visible = false
	player = player_scene.instantiate()
	player.global_position = Vector2(1584, 1030)
	add_child(player)
	player.died.connect(_on_player_died)
	player.damaged.connect(_on_player_damaged)
	player.health_changed.connect(_on_player_health_changed)
	current_room = 0
	_spawn_room(current_room)
	ui_message.text = "区域 1：修复失控玩具"
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
		var tags_text := _format_tags(blessing)
		blessing_buttons[i].text = "%d. [%s]\n%s\n%s" % [i + 1, tags_text, blessing["name"], blessing["description"]]
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
	ui_message.text = "获得修理灵感：%s。区域 %d：修复失控玩具" % [blessing["name"], current_room + 1]
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
	ui_message.text = "黎明前修好了所有玩具。" if victory else "小灯熄灭了，被送回修理台。"

func _format_result_blessings() -> String:
	if acquired_blessings.is_empty():
		return "本晚灵感：暂无"
	var lines: Array[String] = ["本晚灵感："]
	for blessing in acquired_blessings:
		lines.append("- %s" % blessing["name"])
	return "\n".join(lines)

func _setup_ui_style() -> void:
	var panel_style := _make_panel_style(Color(0.12, 0.07, 0.04, 0.82), Color(0.78, 0.55, 0.28, 0.95), 10, 3)
	var side_style := _make_panel_style(Color(0.08, 0.05, 0.035, 0.72), Color(0.42, 0.64, 0.74, 0.8), 8, 2)
	var debug_style := _make_panel_style(Color(0.05, 0.05, 0.06, 0.78), Color(0.55, 0.55, 0.6, 0.7), 6, 2)
	for panel in [start_panel, blessing_panel, result_panel]:
		panel.add_theme_stylebox_override("panel", panel_style)
	for panel in [acquired_blessings_panel]:
		panel.add_theme_stylebox_override("panel", side_style)
	debug_panel.add_theme_stylebox_override("panel", debug_style)
	_style_label(ui_status, 18, Color(0.98, 0.9, 0.72))
	_style_label(ui_message, 18, Color(0.98, 0.86, 0.58))
	_style_label($CanvasLayer/UI/ControlsHint, 15, Color(0.92, 0.82, 0.68, 0.72))
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

func _make_panel_style(fill: Color, border: Color, radius: int, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	style.shadow_size = 10
	return style

func _make_button_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _style_button(button: Button, card := false) -> void:
	var normal := _make_button_style(Color(0.34, 0.18, 0.09, 0.92), Color(0.86, 0.62, 0.32, 0.95))
	var hover := _make_button_style(Color(0.48, 0.28, 0.13, 0.96), Color(0.98, 0.78, 0.42, 1.0))
	var pressed := _make_button_style(Color(0.22, 0.12, 0.07, 0.98), Color(0.98, 0.82, 0.48, 1.0))
	if card:
		normal = _make_button_style(Color(0.16, 0.10, 0.07, 0.94), Color(0.78, 0.55, 0.28, 0.95))
		hover = _make_button_style(Color(0.24, 0.15, 0.09, 0.98), Color(0.98, 0.78, 0.42, 1.0))
		pressed = _make_button_style(Color(0.12, 0.08, 0.055, 1.0), Color(0.98, 0.82, 0.48, 1.0))
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_color_override("font_color", Color(0.98, 0.9, 0.72))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.94, 0.78))
	button.add_theme_font_size_override("font_size", 17 if card else 16)

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

func _on_player_died() -> void:
	_show_result(false)

func _on_player_damaged() -> void:
	if damage_flash_tween != null:
		damage_flash_tween.kill()
	damage_flash.color = Color(1.0, 0.0, 0.0, 0.28)
	damage_flash_tween = create_tween()
	damage_flash_tween.tween_property(damage_flash, "color", Color(1.0, 0.0, 0.0, 0.0), 0.22)

func _on_player_health_changed(current: int, maximum: int) -> void:
	ui_status.text = "HP: %d/%d | 区域: %d/%d | 失控玩具: %d" % [current, maximum, current_room + 1, rooms.size(), enemies_alive]

func _update_status() -> void:
	if player != null:
		ui_status.text = "HP: %d/%d | 区域: %d/%d | 失控玩具: %d" % [player.hp, player.max_hp, current_room + 1, rooms.size(), enemies_alive]
