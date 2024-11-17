extends Node2D
class_name HexaTileSet

signal signal_move_player
signal singal_player_with_tiles

# basically the same thing but different z index
@export var hexa_tile_layer_0: HexaTileLayer
@export var hexa_tile_layer_1: HexaTileLayer

# atlas config
const source_id = 1
const alternative_tile: int = 0
const highlight_all_sides_walkable: Vector2i = Vector2i(2, 0)
const highlight_all_sides_resource: Vector2i = Vector2i(1, 0)

# tile groups
const resource_tiles: Array[Vector2i] = [Vector2i(4, 1), Vector2i(2, 2)]
const walkable_tiles: Array[Vector2i] = [Vector2i(5, 3), Vector2i(4, 3)]

# tiles which cannont be selected -> random terrain
const not_selectable_tile: Vector2i = Vector2i(1, 1)

# selection
var selected_walkable_tiles: Array[Vector2i] = []
const max_size_selected_walkable: int = 1

var selected_resource_tiles: Array[Vector2i] = []
const max_size_selected_resource: int = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hexa_tile_layer_0.cell_action.connect(cell_action)

	# set z index
	hexa_tile_layer_0.z_index = 0
	hexa_tile_layer_1.z_index = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cell_action(pos_clicked: Vector2i, select: bool, reuqested_from_game_manager: bool) -> void:
	"""
	:param pos_clicked: position of the cell clicked
	:param select: if true, select the cell, if false, deselect the cell
	"""
	var action_player_movement: bool = false
	var action_player_with_tile: bool = false

	var action_requested_on_tile_cords: Vector2i = hexa_tile_layer_0.get_cell_atlas_coords(pos_clicked)

	# blacklisted tiles
	if action_requested_on_tile_cords == not_selectable_tile:
		return

	# withelisted tiles
	if action_requested_on_tile_cords in walkable_tiles:
		action_player_movement = true

	if action_requested_on_tile_cords in resource_tiles and reuqested_from_game_manager:
		action_player_with_tile = true

	if not action_player_movement and not action_player_with_tile:
		return

	if action_player_movement and not reuqested_from_game_manager:
		selection_on_different_tiles(
			pos_clicked,
			select,
			highlight_all_sides_walkable,
			selected_walkable_tiles,
			max_size_selected_walkable,
			signal_move_player,
			reuqested_from_game_manager,
		)
	elif action_player_with_tile:
		selection_on_different_tiles(
			pos_clicked,
			select,
			highlight_all_sides_resource,
			selected_resource_tiles,
			max_size_selected_resource,
			singal_player_with_tiles,
			reuqested_from_game_manager,
		)

func clear_selected_resource_tiles() -> void:
	var tiles_to_be_cleared: Array[Vector2i] = selected_resource_tiles.duplicate()
	for tile in tiles_to_be_cleared:
		# only called by the game manager
		cell_action(tile, false, true)

func clear_selected_walkable_tiles() -> void:
	var tiles_to_be_cleared: Array[Vector2i] = selected_walkable_tiles.duplicate()
	for tile in tiles_to_be_cleared:
		cell_action(tile, false, false)


func selection_on_different_tiles(
	pos_clicked: Vector2i,
	select: bool,
	highlight_tile: Vector2i,
	selected_tiles: Array[Vector2i],
	max_size_selected: int,
	signal_game_manager: Signal,
	requested_from_game_manager: bool,
) -> void:
	if select:
		if pos_clicked not in selected_tiles:
			# update cell hihglight and add to selected_tiles
			hexa_tile_layer_1.set_cell(pos_clicked, source_id, highlight_tile)
			selected_tiles.append(pos_clicked)

			# determine if we need to delete latest selected tile -> de-select
			if selected_tiles.size() > max_size_selected:
				cell_action(selected_tiles.pop_front(), false, requested_from_game_manager)

			if Global.debug == true:
				print("selected tiles: ", selected_tiles)

			signal_game_manager.emit(selected_tiles)
	else:
		# ***de-select***
		# tile and remove from selected_tiles
		# select random different source id where we do not have sprite
		hexa_tile_layer_1.set_cell(pos_clicked, source_id - 1, highlight_tile)
		selected_tiles.erase(pos_clicked)

		if Global.debug == true:
			print("de-selected tile: ", pos_clicked)

func get_neighbours(pos: Vector2i) -> Array[Vector2i]:
	"""
	:param pos: position of the cell
	:return: Array of neighbours
	"""
	return hexa_tile_layer_0.get_surrounding_cells(pos)