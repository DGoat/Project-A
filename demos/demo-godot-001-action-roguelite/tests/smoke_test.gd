extends SceneTree

var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_project_actions()
	_test_main_scene_start_flow()
	_test_player_core_values()
	_test_player_dash_motion()
	_test_player_attack_shape()
	_test_ranged_enemy_motion()
	_test_enemy_separation_group()
	_report()
	quit(1 if failures.size() > 0 else 0)

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _test_project_actions() -> void:
	for action in ["move_up", "move_down", "move_left", "move_right", "attack", "dash", "restart", "pick_blessing_1", "pick_blessing_2", "pick_blessing_3"]:
		_expect(InputMap.has_action(action), "missing input action: %s" % action)

func _test_main_scene_start_flow() -> void:
	var main_scene := load("res://scenes/Main.tscn")
	_expect(main_scene != null, "Main.tscn failed to load")
	if main_scene == null:
		return
	var main = main_scene.instantiate()
	root.add_child(main)
	await process_frame
	_expect(main.has_node("RepairTableBg"), "missing RepairTableBg")
	_expect(main.has_node("RoomRoot"), "missing RoomRoot")
	_expect(main.has_node("CanvasLayer/UI/StartPanel"), "missing StartPanel")
	main._start_run()
	await process_frame
	_expect(main.player != null, "player not spawned after _start_run")
	_expect(main.enemies_alive > 0, "room enemies not spawned after _start_run")
	_expect(main.current_room == 0, "run should start at room 0")
	main.queue_free()

func _test_player_core_values() -> void:
	var player_scene := load("res://scenes/Player.tscn")
	_expect(player_scene != null, "Player.tscn failed to load")
	if player_scene == null:
		return
	var player = player_scene.instantiate()
	root.add_child(player)
	await process_frame
	_expect(player.attack_length >= 65.0, "player attack_length should match enlarged character")
	_expect(player.attack_width >= 47.0, "player attack_width should match enlarged character")
	_expect(player.has_node("Camera2D"), "player missing Camera2D")
	_expect(player.has_node("AttackSprite"), "player missing AttackSprite")
	player.queue_free()

func _test_player_dash_motion() -> void:
	var player = load("res://scenes/Player.tscn").instantiate()
	root.add_child(player)
	await process_frame
	player.facing = Vector2.RIGHT
	player.dash_time = player.dash_duration
	player._physics_process(0.016)
	_expect(player.velocity.x > player.move_speed, "dash should set velocity above move speed")
	player.queue_free()

func _test_player_attack_shape() -> void:
	var player = load("res://scenes/Player.tscn").instantiate()
	root.add_child(player)
	await process_frame
	player.attack_length = 78.0
	player.attack_width = 52.0
	player._update_attack_shape()
	var shape := player.attack_shape.shape as RectangleShape2D
	_expect(shape != null, "attack shape is not RectangleShape2D")
	if shape != null:
		_expect(shape.size == Vector2(78.0, 52.0), "attack shape size not synced")
	player.queue_free()

func _test_ranged_enemy_motion() -> void:
	var player = load("res://scenes/Player.tscn").instantiate()
	var enemy = load("res://scenes/RangedEnemy.tscn").instantiate()
	root.add_child(player)
	root.add_child(enemy)
	await process_frame
	player.global_position = Vector2(1000, 1000)
	enemy.global_position = Vector2(100, 100)
	enemy.player = player
	enemy._physics_process(0.016)
	_expect(enemy.velocity.length() > 0.0, "ranged enemy should move when far from player")
	enemy.queue_free()
	player.queue_free()

func _test_enemy_separation_group() -> void:
	var main_scene := load("res://scenes/Main.tscn")
	var main = main_scene.instantiate()
	root.add_child(main)
	await process_frame
	main._start_run()
	await process_frame
	for enemy in main.room_root.get_children():
		_expect(enemy.is_in_group("enemies"), "spawned enemy should be in enemies group")
	main.queue_free()

func _report() -> void:
	if failures.is_empty():
		print("AI_TEST_PASS")
		return
	print("AI_TEST_FAIL")
	for failure in failures:
		push_error(failure)
