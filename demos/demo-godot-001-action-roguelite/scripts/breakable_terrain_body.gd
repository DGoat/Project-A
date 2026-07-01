extends StaticBody2D

var hp := 20
var tile_layer: TileMapLayer
var tile_origin_cell := Vector2i.ZERO
var tile_footprint := Vector2i(1, 1)

func _ready() -> void:
	if has_meta("hp"):
		hp = int(get_meta("hp"))
	if has_meta("tile_layer_path"):
		tile_layer = get_node_or_null(get_meta("tile_layer_path")) as TileMapLayer
	if has_meta("tile_origin_cell"):
		tile_origin_cell = get_meta("tile_origin_cell")
	if has_meta("tile_footprint"):
		tile_footprint = get_meta("tile_footprint")

func take_damage(amount: int, _source: Node = null, _damage_type := "direct") -> void:
	hp -= amount
	if hp <= 0:
		_clear_tile_cells()
		queue_free()

func _clear_tile_cells() -> void:
	if tile_layer == null:
		return
	for y in range(maxi(tile_footprint.y, 1)):
		for x in range(maxi(tile_footprint.x, 1)):
			tile_layer.erase_cell(tile_origin_cell + Vector2i(x, y))
