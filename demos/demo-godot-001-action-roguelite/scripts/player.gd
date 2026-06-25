extends CharacterBody2D

signal died
signal health_changed(current: int, maximum: int)
signal enemy_killed

var max_hp := 100
var hp := 100
var move_speed := 240.0
var dash_speed := 620.0
var dash_duration := 0.16
var dash_cooldown := 0.55
var attack_damage := 20.0
var attack_cooldown := 0.35
var attack_range := 56.0
var heal_on_kill := 0
var burn_damage := 0
var burn_ticks := 0
var dash_strike_multiplier := 1.0

var facing := Vector2.RIGHT
var dash_time := 0.0
var dash_cooldown_time := 0.0
var attack_cooldown_time := 0.0
var dash_strike_ready := false
var invulnerable_time := 0.0
var hurt_invulnerable_duration := 0.65
var dead := false

@onready var body := $Body
@onready var health_bar_fill := $HealthBarFill
@onready var attack_preview := $AttackPreview
@onready var attack_area := $AttackArea
@onready var attack_shape := $AttackArea/CollisionShape2D

func _ready() -> void:
	attack_area.body_entered.connect(_on_attack_body_entered)
	_update_health_bar()
	health_changed.emit(hp, max_hp)

func _physics_process(delta: float) -> void:
	if dead:
		return

	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector.length() > 0.0:
		facing = input_vector.normalized()

	dash_cooldown_time = maxf(0.0, dash_cooldown_time - delta)
	attack_cooldown_time = maxf(0.0, attack_cooldown_time - delta)
	invulnerable_time = maxf(0.0, invulnerable_time - delta)

	if dash_time > 0.0:
		dash_time -= delta
		velocity = facing * dash_speed
	else:
		velocity = input_vector * move_speed
		if Input.is_action_just_pressed("dash") and dash_cooldown_time <= 0.0:
			dash_time = dash_duration
			dash_cooldown_time = dash_cooldown
			dash_strike_ready = dash_strike_multiplier > 1.0

	move_and_slide()
	_update_visuals()

	if Input.is_action_just_pressed("attack") and attack_cooldown_time <= 0.0:
		attack()

func attack() -> void:
	attack_cooldown_time = attack_cooldown
	attack_area.position = facing * attack_range
	attack_preview.position = attack_area.position
	attack_preview.visible = true
	attack_shape.disabled = false
	await get_tree().create_timer(0.08).timeout
	attack_shape.disabled = true
	if is_instance_valid(attack_preview):
		attack_preview.visible = false

func take_damage(amount: int) -> void:
	if dead or invulnerable_time > 0.0:
		return
	invulnerable_time = hurt_invulnerable_duration
	hp = max(0, hp - amount)
	_update_health_bar()
	health_changed.emit(hp, max_hp)
	body.modulate = Color(1.0, 0.55, 0.55)
	await get_tree().create_timer(0.08).timeout
	if is_instance_valid(body):
		body.modulate = Color(0.2, 0.9, 0.45)
	if hp == 0:
		dead = true
		died.emit()

func apply_blessing(blessing: Dictionary) -> void:
	var effects: Dictionary = blessing.get("effects", {})
	if effects.has("attack_damage_multiplier"):
		attack_damage *= float(effects["attack_damage_multiplier"])
	if effects.has("attack_cooldown_multiplier"):
		attack_cooldown *= float(effects["attack_cooldown_multiplier"])
	if effects.has("dash_strike_multiplier"):
		dash_strike_multiplier = maxf(dash_strike_multiplier, float(effects["dash_strike_multiplier"]))
	if effects.has("heal_on_kill"):
		heal_on_kill += int(effects["heal_on_kill"])
	if effects.has("burn_damage"):
		burn_damage = max(burn_damage, int(effects["burn_damage"]))
		burn_ticks = max(burn_ticks, int(effects.get("burn_ticks", 0)))
	if effects.has("attack_range_multiplier"):
		attack_range *= float(effects["attack_range_multiplier"])

func heal(amount: int) -> void:
	hp = min(max_hp, hp + amount)
	_update_health_bar()
	health_changed.emit(hp, max_hp)

func _on_attack_body_entered(body_node: Node2D) -> void:
	if not body_node.has_method("take_damage"):
		return
	var damage := attack_damage
	if dash_strike_ready:
		damage *= dash_strike_multiplier
		dash_strike_ready = false
	body_node.take_damage(int(round(damage)), self)
	if burn_damage > 0 and body_node.has_method("apply_burn"):
		body_node.apply_burn(burn_damage, burn_ticks, self)

func notify_enemy_killed() -> void:
	if heal_on_kill > 0:
		heal(heal_on_kill)
	enemy_killed.emit()

func _update_health_bar() -> void:
	var ratio := float(hp) / float(max_hp)
	health_bar_fill.offset_right = -19.0 + 38.0 * ratio

func _update_visuals() -> void:
	body.rotation = facing.angle()
