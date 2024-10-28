extends Node2D
class_name HexaTileSet

# basically the same thing but different z index
@export var hexa_tile_layer_0: HexaTileLayer
@export var hexa_tile_layer_1: HexaTileLayer

# atlas config
const source_id = 1
const alternative_tile: int = 0
const highlight_all_sides: Vector2i = Vector2i(2, 0)
const walkable_tile: Vector2i = Vector2i(5, 3)
const not_selectable_tile: Vector2i = Vector2i(1, 1)

# selection
var selected_walkable_tiles: Array = []
const max_size_selected_walkable: int = 1

var selected_resource_tiles: Array = []
const max_size_selected_resource: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hexa_tile_layer_0.cell_action.connect(cell_action)

	# set z index
	hexa_tile_layer_0.z_index = 0
	hexa_tile_layer_1.z_index = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func cell_action(pos_clicked: Vector2i, select: bool) -> void:
	"""
	:param pos_clicked: position of the cell clicked
	:param select: if true, select the cell, if false, deselect the cell
	"""

	if Global.debug == true:
		print("action on cell: ", pos_clicked)

	var tmp_atlas_cords: Vector2i = hexa_tile_layer_0.get_cell_atlas_coords(pos_clicked)
	if not_selectable_tile == tmp_atlas_cords:
		return

	if select:
		if pos_clicked not in selected_walkable_tiles:
			# update cell hihglight and add to selected_walkable_tiles
			hexa_tile_layer_1.set_cell(pos_clicked, source_id, highlight_all_sides)
			selected_walkable_tiles.append(pos_clicked)

			# determine if we need to delete latest selected tile
			if selected_walkable_tiles.size() > max_size_selected_walkable:
				var tmp_pos: Vector2i = selected_walkable_tiles.pop_front()
				cell_action(tmp_pos, false)
	else:
		# deselect tile and remove from selected_walkable_tiles
		# select random different source id where we do not have sprite
		hexa_tile_layer_1.set_cell(pos_clicked, source_id - 1, highlight_all_sides)
		selected_walkable_tiles.erase(pos_clicked)
