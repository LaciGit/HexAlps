extends Node2D
class_name HexaTileSet

# basically the same thing but different z index
@export var hexa_tile_layer_0: HexaTileLayer
@export var hexa_tile_layer_1: HexaTileLayer

# atlas config
const source_id = 1
const alternative_tile: int = 0
const highlight_all_sides: Vector2i = Vector2i(2, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hexa_tile_layer_0.cell_action.connect(cell_action)

	# set z index
	hexa_tile_layer_0.z_index = 0
	hexa_tile_layer_1.z_index = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func cell_action(pos_clicked: Vector2i) -> void:
	if Global.debug == true:
		print(pos_clicked)

	hexa_tile_layer_1.set_cell(pos_clicked, source_id, highlight_all_sides)
