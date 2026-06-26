extends CharacterBody2D

signal died(enemy: Node)

@export var max_hp := 30
@export var move_speed := 70.0
@export var preferred_distance := 300.0
@export var shoot_cooldown := 1.8
@export var knockback_speed := 220.0
@export var knockback_duration := 0.12

var hp := 30
var player: Node2D
var shoot_time := 0.0
var burn_damage := 0
var burn_ticks_left := 0
var burn_owner: Node
var burn_timer := 0.0
var knockback_time := 0.0
var knockback_direction := Vector2.ZERO
var dead := false
var projectile_scene := preload("res://scenes/Projectile.tscn")

@onready var body := $Body

func _ready() -> void:
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
		velocity = -to_player * move_speed
	elif distance > preferred_distance:
		velocity = to_player * move_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	body.flip_h = to_player.x < 0

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
	var projectile := projectile_scene.instantiate()
	projectile.global_position = global_position + direction * 24.0
	projectile.direction = direction
	get_tree().current_scene.add_child(projectile)

func _refresh_body_color() -> void:
	body.modulate = Color(1.25, 0.75, 0.35) if burn_ticks_left > 0 else Color(1.0, 1.0, 1.0)

func _die(source: Node = null) -> void:
	dead = true
	if source != null and source.has_method("notify_enemy_killed"):
		source.notify_enemy_killed()
	died.emit(self)
	queue_free()
