extends Area2D

@export var speed := 320.0
@export var damage := 12
@export var lifetime := 3.0

var direction := Vector2.RIGHT

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
