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
	_test_player_play_area_margin()
	_test_player_slow_multiplier()
	_test_player_walk_sheet()
	_test_ranged_enemy_motion()
	_test_enemy_separation_group()
	_test_terrain_collision_masks()
	_test_terrain_tilesheet()
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
	_expect(main.has_node("RoomBackgrounds"), "missing RoomBackgrounds")
	_expect(main.room_backgrounds.size() >= 3, "main should define per-room background slots")
	_expect(main.get_node("RepairTableBg").z_index < main.map_root.z_index, "room background should render below terrain")
	_expect(main.room_root.z_index > main.map_root.z_index, "enemies should render above ground terrain")
	_expect(main.has_node("RoomRoot"), "missing RoomRoot")
	_expect(main.has_node("CanvasLayer/UI/StartPanel"), "missing StartPanel")
	_expect(main.player_scene != null, "missing player scene preload")
	main._start_run()
	await process_frame
	_expect(main.player != null, "player not spawned after _start_run")
	_expect(main.enemies_alive > 0, "room enemies not spawned after _start_run")
	_expect(main.current_room == 0, "run should start at room 0")
	_expect(main.get_node("RoomBackgrounds").get_child_count() == 3, "editor should show three separated room backgrounds")
	_expect(main.map_root.get_node("ManualTerrainRoom2").position.x > main.room_size.x, "room 2 terrain should be horizontally separated")
	for room_index in range(main.rooms.size()):
		main._spawn_room(room_index)
		await process_frame
		_expect(main.player.global_position == main._get_room_local_position(room_index, Vector2(1584, 1030)), "player should move to room %d spawn" % [room_index + 1])
		var camera := main.player.get_node("Camera2D") as Camera2D
		_expect(camera.limit_left == int(main._get_room_offset(room_index).x), "camera left limit should match room %d" % [room_index + 1])
		_expect(camera.limit_right == int(main._get_room_offset(room_index).x + main.room_size.x), "camera right limit should match room %d" % [room_index + 1])
		var nav_region := main.map_root.get_node("NavigationRegion2D") as NavigationRegion2D
		var nav_outline := nav_region.navigation_polygon.get_outline(0)
		_expect(nav_outline[0].x == main._get_room_offset(room_index).x + 120.0, "navigation region should match room %d" % [room_index + 1])
		for enemy in main.room_root.get_children():
			_expect(enemy.global_position.x >= main._get_room_offset(room_index).x, "enemy should spawn in room %d area" % [room_index + 1])
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
	_expect(player.idle_texture != null, "player missing idle texture")
	_expect(player.walk_texture != null, "player missing walk texture")
	_expect(player.walk_sheet_texture != null, "player missing walk sheet texture")
	_expect(player.attack_texture != null, "player missing attack texture")
	_expect(player.hurt_texture != null, "player missing hurt texture")
	_expect(player.down_texture != null, "player missing down texture")
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

func _test_player_play_area_margin() -> void:
	var player = load("res://scenes/Player.tscn").instantiate()
	root.add_child(player)
	await process_frame
	_expect(player.play_area_min == Vector2(80.0, 120.0), "player play area min should keep visibility margin")
	_expect(player.play_area_max == Vector2(3088.0, 1264.0), "player play area max should keep visibility margin")
	player.global_position = Vector2(-200.0, -200.0)
	player._physics_process(0.016)
	_expect(player.global_position.x >= player.play_area_min.x and player.global_position.y >= player.play_area_min.y, "player should clamp to play area min")
	player.queue_free()

func _test_player_slow_multiplier() -> void:
	var player = load("res://scenes/Player.tscn").instantiate()
	root.add_child(player)
	await process_frame
	player.set_slow_multiplier(0.65)
	_expect(player.slow_multiplier == 0.65, "player slow multiplier not applied")
	player.set_slow_multiplier(1.0)
	_expect(player.slow_multiplier == 1.0, "player slow multiplier not restored")
	player.queue_free()

func _test_player_walk_sheet() -> void:
	var player = load("res://scenes/Player.tscn").instantiate()
	root.add_child(player)
	await process_frame
	player.velocity = Vector2.RIGHT * player.move_speed
	player._update_action_texture()
	_expect(player.body.texture == player.walk_sheet_texture, "moving player should use walk sheet")
	_expect(player.body.hframes == 2 and player.body.vframes == 2, "walk sheet should be 2x2")
	_expect(player._get_visual_scale_multiplier() == player.walk_sheet_scale_multiplier, "walk sheet should use scale compensation")
	player.velocity = Vector2.ZERO
	player._update_action_texture()
	_expect(player.body.texture == player.idle_texture, "idle player should use idle texture")
	_expect(player.body.hframes == 1 and player.body.vframes == 1, "idle texture should reset sheet frames")
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
		_expect(main.map_root.get_child_count() > 0, "room map should spawn obstacles or hazards")
		_expect(main.map_root.has_node("NavigationRegion2D"), "room map should spawn NavigationRegion2D")
		_expect(not main.map_root.has_node("Obstacle"), "legacy generated obstacles should not spawn with TileMap terrain")
		_expect(main.map_root.has_node("BoundaryHint"), "room map should spawn BoundaryHint")
	_expect(main.map_root.has_node("ManualTerrainRoom1"), "MapRoot should include ManualTerrainRoom1")
	_expect(main.map_root.has_node("ManualTerrainRoom2"), "MapRoot should include ManualTerrainRoom2")
	_expect(main.map_root.has_node("ManualTerrainRoom3"), "MapRoot should include ManualTerrainRoom3")
	_expect(main.map_root.get_node("ManualTerrainRoom1").visible, "room 1 manual terrain layer should be visible in room 1")
	_expect(not main.map_root.get_node("ManualTerrainRoom2").visible, "room 2 manual terrain layer should be hidden in room 1")
	main.queue_free()

func _test_terrain_collision_masks() -> void:
	var player = load("res://scenes/Player.tscn").instantiate()
	var melee = load("res://scenes/MeleeEnemy.tscn").instantiate()
	var ranged = load("res://scenes/RangedEnemy.tscn").instantiate()
	_expect(player.collision_layer == 1, "player should stay on collision layer 1")
	_expect((player.get_node("AttackArea").collision_mask & 8) != 0, "player attack should hit breakable terrain layer")
	_expect((player.collision_mask & 8) != 0, "player should collide with terrain layer")
	_expect((melee.collision_mask & 8) != 0, "melee enemy should collide with terrain layer")
	_expect(melee.has_node("NavigationAgent2D"), "melee enemy should have NavigationAgent2D")
	_expect((ranged.collision_mask & 8) != 0, "ranged enemy should collide with terrain layer")
	_expect(ranged.has_node("NavigationAgent2D"), "ranged enemy should have NavigationAgent2D")
	_expect(ranged.has_method("_has_clear_shot"), "ranged enemy should check line of sight before shooting")
	_expect(ranged.has_method("_find_attack_position"), "ranged enemy should find attack position when shot is blocked")
	player.queue_free()
	melee.queue_free()
	ranged.queue_free()

func _test_terrain_tilesheet() -> void:
	var main_scene := load("res://scenes/Main.tscn")
	var main = main_scene.instantiate()
	root.add_child(main)
	await process_frame
	_expect(main.terrain_tilesheet != null, "main should preload terrain tilesheet")
	_expect(main.terrain_atlas.has("toolbox_center"), "terrain atlas should include toolbox_center")
	_expect(main.has_method("_create_manual_terrain"), "main should support manual terrain placement")
	_expect(main.has_method("_get_obstacle_atlas_key"), "main should support obstacle atlas override")
	_expect(main.has_method("_update_manual_terrain_layers"), "main should support room-specific manual terrain layers")
	_expect(main.has_method("_show_all_manual_terrain_layers_in_editor"), "main should keep room terrain layers editable in editor")
	_expect(main.has_method("_spawn_tilemap_terrain"), "main should generate terrain logic from TileMapLayer")
	_expect(main.has_method("_update_player_camera_limits"), "main should update camera limits per room")
	_expect(main.has_method("_update_room_background"), "main should support per-room backgrounds")
	_expect(main.has_method("_apply_render_layers"), "main should define render layer ordering")
	_expect(main.has_method("_get_terrain_footprint_cells"), "main should support multi-cell terrain footprint")
	_expect(main.has_method("_create_tile_breakable_body"), "main should support breakable terrain body")
	_expect(main.terrain_tile_properties[Vector2i(0, 0)].has("footprint"), "terrain tile properties should define footprint")
	var room1 := main.map_root.get_node("ManualTerrainRoom1") as TileMapLayer
	room1.set_cell(Vector2i(5, 5), 0, Vector2i(0, 4))
	main._spawn_room_map(0)
	await process_frame
	var found_sprite := false
	var found_tile_body := false
	for node in main.map_root.get_children():
		if node.name == "Obstacle":
			for child in node.get_children():
				if child is Sprite2D:
					found_sprite = true
		if node.name == "TileTerrainBody":
			found_tile_body = true
	_expect(not found_sprite, "legacy obstacle Sprite2D visuals should be disabled for TileMap terrain")
	_expect(found_tile_body, "TileMap hard terrain should generate TileTerrainBody")
	main.queue_free()

func _report() -> void:
	if failures.is_empty():
		print("AI_TEST_PASS")
		return
	print("AI_TEST_FAIL")
	for failure in failures:
		push_error(failure)
