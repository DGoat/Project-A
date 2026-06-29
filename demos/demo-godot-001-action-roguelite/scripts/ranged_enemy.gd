extends CharacterBody2D

signal died(enemy: Node)

@export var max_hp := 30
@export var move_speed := 70.0
@export var preferred_distance := 300.0
@export var shoot_cooldown := 1.8
@export var knockback_speed := 220.0
@export var knockback_duration := 0.12
@export var separation_radius := 46.0
@export var separation_strength := 120.0
@export var obstacle_avoid_distance := 58.0
@export var obstacle_avoid_strength := 140.0

var hp := 30
var player: Node2D
var shoot_time := 0.0
var burn_damage := 0
var burn_ticks_left := 0
var burn_owner: Node
var burn_timer := 0.0
var knockback_time := 0.0
var knockback_direction := Vector2.ZERO
var visual_time := 0.0
var body_base_position := Vector2.ZERO
var body_base_scale := Vector2.ONE
var dead := false
var projectile_scene := preload("res://scenes/Projectile.tscn")

@onready var body := $Body
@onready var navigation_agent := $NavigationAgent2D

func _ready() -> void:
	body_base_position = body.position
	body_base_scale = body.scale
	hp = max_hp
	shoot_time = shoot_cooldown * 0.7
	_refresh_body_color()

func _physics_process(delta: float) -> void:
	if dead or player == null:
		return
	var to_player := global_position.direction_to(player.global_position)
	var distance := global_position.distance_to(player.global_position)
	if knockback_time > 0.0:
		knockback_time -= delta
		velocity = knockback_direction * knockback_speed
	elif distance < preferred_distance * 0.75:
		velocity = _get_navigation_velocity(global_position - to_player * preferred_distance)
	elif distance > preferred_distance:
		velocity = _get_navigation_velocity(player.global_position)
	else:
		velocity = Vector2.ZERO
	velocity += _get_separation_velocity()
	move_and_slide()
	body.flip_h = to_player.x < 0
	_update_visuals(delta)

	shoot_time -= delta
	if shoot_time <= 0.0:
		shoot_time = shoot_cooldown
		_shoot(to_player)
	_process_burn(delta)

func take_damage(amount: int, source: Node = null, damage_type := "direct") -> void:
	if dead:
		return
	if damage_type == "direct" and source != null:
		knockback_direction = source.global_position.direction_to(global_position).normalized()
		knockback_time = knockback_duration
	hp -= amount
	if damage_type == "burn":
		body.modulate = Color(1.0, 0.45, 0.05)
	else:
		body.modulate = Color(1.0, 0.55, 0.55)
	var hit_tween := create_tween()
	hit_tween.tween_property(body, "scale", body_base_scale * 1.12, 0.035)
	hit_tween.tween_property(body, "scale", body_base_scale, 0.055)
	await get_tree().create_timer(0.06).timeout
	if is_instance_valid(body):
		_refresh_body_color()
	if hp <= 0:
		_die(source)

func apply_burn(amount: int, ticks: int, source: Node = null) -> void:
	burn_damage = amount
	burn_ticks_left = ticks
	burn_owner = source
	burn_timer = 0.45
	_refresh_body_color()

func _process_burn(delta: float) -> void:
	if burn_ticks_left <= 0:
		return
	burn_timer -= delta
	if burn_timer <= 0.0:
		burn_ticks_left -= 1
		burn_timer = 0.45
		take_damage(burn_damage, burn_owner, "burn")
		if burn_ticks_left <= 0:
			_refresh_body_color()

func _shoot(direction: Vector2) -> void:
	body.modulate = Color(1.35, 1.2, 0.75)
	var shoot_tween := create_tween()
	shoot_tween.tween_property(body, "scale", body_base_scale * 1.14, 0.06)
	shoot_tween.tween_property(body, "scale", body_base_scale, 0.08)
	shoot_tween.finished.connect(_refresh_body_color)
	var projectile := projectile_scene.instantiate()
	projectile.global_position = global_position + direction * 24.0
	projectile.direction = direction
	get_tree().current_scene.add_child(projectile)

func _refresh_body_color() -> void:
	body.modulate = Color(1.25, 0.75, 0.35) if burn_ticks_left > 0 else Color(1.0, 1.0, 1.0)

func _get_navigation_velocity(target_position: Vector2) -> Vector2:
	navigation_agent.target_position = target_position
	var next_position: Vector2 = navigation_agent.get_next_path_position()
	if navigation_agent.is_navigation_finished() or global_position.distance_to(next_position) < 3.0:
		return global_position.direction_to(target_position) * move_speed
	return global_position.direction_to(next_position) * move_speed

func _get_separation_velocity() -> Vector2:
	var separation := Vector2.ZERO
	for node in get_tree().get_nodes_in_group("enemies"):
		var other := node as Node2D
		if other == null or other == self:
			continue
		var offset: Vector2 = global_position - other.global_position
		var distance := offset.length()
		if distance > 0.0 and distance < separation_radius:
			separation += offset.normalized() * ((separation_radius - distance) / separation_radius)
	return separation * separation_strength

func _get_obstacle_avoidance_velocity(direction: Vector2) -> Vector2:
	var avoidance := Vector2.ZERO
	var side := direction.orthogonal().normalized()
	for node in get_tree().get_nodes_in_group("obstacles"):
		var obstacle := node as StaticBody2D
		if obstacle == null:
			continue
		var shape_node := obstacle.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if shape_node == null or not shape_node.shape is RectangleShape2D:
			continue
		var rect := shape_node.shape as RectangleShape2D
		var local := global_position - obstacle.global_position
		var half := rect.size * 0.5
		var closest := Vector2(clampf(local.x, -half.x, half.x), clampf(local.y, -half.y, half.y))
		var offset := local - closest
		var distance := offset.length()
		var ahead := (obstacle.global_position - global_position).dot(direction)
		if ahead > -12.0 and ahead < obstacle_avoid_distance and distance < obstacle_avoid_distance:
			var side_sign := signf((obstacle.global_position - global_position).dot(side))
			if side_sign == 0.0:
				side_sign = 1.0
			avoidance -= side * side_sign * ((obstacle_avoid_distance - distance) / obstacle_avoid_distance)
	return avoidance * obstacle_avoid_strength

func _update_visuals(delta: float) -> void:
	visual_time += delta
	var bob := sin(visual_time * 8.0) * 1.2
	body.position = body_base_position + Vector2(0.0, bob)

func _die(source: Node = null) -> void:
	dead = true
	var tween := create_tween()
	tween.tween_property(body, "scale", body_base_scale * 0.45, 0.16)
	tween.parallel().tween_property(body, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.16)
	tween.finished.connect(func():
		if source != null and source.has_method("notify_enemy_killed"):
			source.notify_enemy_killed()
		died.emit(self)
		queue_free()
	)
