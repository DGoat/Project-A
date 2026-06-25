extends CharacterBody2D

signal died(enemy: Node)

@export var max_hp := 40
@export var move_speed := 120.0
@export var contact_damage := 10
@export var recoil_speed := 260.0
@export var recoil_duration := 0.18
@export var elite := false

var hp := 40
var player: Node2D
var burn_damage := 0
var burn_ticks_left := 0
var burn_owner: Node
var burn_timer := 0.0
var recoil_time := 0.0
var recoil_direction := Vector2.ZERO
var dead := false

@onready var body := $Body
@onready var contact_area := $ContactArea

func _ready() -> void:
	hp = max_hp
	if elite:
		hp = 90
		max_hp = 90
		move_speed = 145.0
		contact_damage = 16
		body.scale = Vector2(1.35, 1.35)
	contact_area.body_entered.connect(_on_contact_body_entered)

func _physics_process(delta: float) -> void:
	if dead or player == null:
		return
	var direction := global_position.direction_to(player.global_position)
	if recoil_time > 0.0:
		recoil_time -= delta
		velocity = recoil_direction * recoil_speed
	else:
		velocity = direction * move_speed
	move_and_slide()
	body.rotation = direction.angle()
	_process_burn(delta)

func take_damage(amount: int, source: Node = null) -> void:
	if dead:
		return
	hp -= amount
	body.modulate = Color(1.0, 0.45, 0.45)
	await get_tree().create_timer(0.06).timeout
	if is_instance_valid(body):
		body.modulate = Color(1.0, 0.35, 0.25) if elite else Color(0.9, 0.25, 0.25)
	if hp <= 0:
		_die(source)

func apply_burn(amount: int, ticks: int, source: Node = null) -> void:
	burn_damage = amount
	burn_ticks_left = ticks
	burn_owner = source
	burn_timer = 0.45

func _process_burn(delta: float) -> void:
	if burn_ticks_left <= 0:
		return
	burn_timer -= delta
	if burn_timer <= 0.0:
		burn_ticks_left -= 1
		burn_timer = 0.45
		take_damage(burn_damage, burn_owner)

func _on_contact_body_entered(body_node: Node2D) -> void:
	if body_node.has_method("take_damage"):
		body_node.take_damage(contact_damage)
		recoil_direction = body_node.global_position.direction_to(global_position).normalized()
		recoil_time = recoil_duration

func _die(source: Node = null) -> void:
	dead = true
	if source != null and source.has_method("notify_enemy_killed"):
		source.notify_enemy_killed()
	died.emit(self)
	queue_free()
