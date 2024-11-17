extends Node
class_name GameManager

# Tilemap
## game board
@export var hexa_tile_set: HexaTileSet

## layer 0 where the player will be
@export var hexa_tile_layer_0: HexaTileLayer

# camera
@export var camera_over_player: Camera2D

# GameInterface
@export var game_interface: GameInterface

# Player
## resources
var path_player: PackedScene = preload("res://scenes/characters/player.tscn")
var player: Player = null


func _ready() -> void:
	if not player:
		var tmp_player = path_player.instantiate()
		var local_map_pos = hexa_tile_layer_0.map_to_local(Vector2i(0, 0))
		tmp_player.position = local_map_pos
		add_child(tmp_player)

		# set player
		player = tmp_player

	# connect signals
	game_interface.next_turn.connect(on_next_turn)
	hexa_tile_set.signal_move_player.connect(on_player_move)
	hexa_tile_set.singal_player_with_tiles.connect(on_player_with_tiles)


func on_next_turn() -> void:
	update_player_stats()

func on_player_with_tiles(selected_walkable_tiles: Array[Vector2i]) -> void:
	# game manager should do something if player selects a resource tile
	pass

func on_player_move(selected_walkable_tiles: Array[Vector2i]) -> void:
	"""move player to selected walkable tiles
	:param selected_walkable_tiles: Array of selected walkable tiles Array[vector2i]
	"""
	# do not move player
	var current_player_pos: Vector2i = hexa_tile_layer_0.local_to_map(player.position)
	if current_player_pos == selected_walkable_tiles[0] or player.energy <= 0:
		return

	# check if selected walkable tiles are neighbouring to player
	var current_player_neighbours: Array[Vector2i] = hexa_tile_set.get_neighbours(current_player_pos)
	if selected_walkable_tiles[0] not in current_player_neighbours:
		return

	if Global.debug:
		print("move player to: ", selected_walkable_tiles)

	# clear selected resource tiles
	hexa_tile_set.clear_selected_resource_tiles()

	# convert selected walkable tiles to local position before sending to player
	var local_selected_walkable_tiles = selected_walkable_tiles.map(
			func(x: Vector2i): return hexa_tile_layer_0.map_to_local(x)
		)

	# since we currently only allow to move to neighbouring tiles -> movement done is 1
	player.move_player(local_selected_walkable_tiles, 1)
	update_progress_bar_energy()

	# check if resources are neighbouring to player and we have to select them#
	var neighbours = hexa_tile_set.get_neighbours(hexa_tile_layer_0.local_to_map(player.position))
	for neighbour in neighbours:
		hexa_tile_set.cell_action(neighbour, true, true)

	# update player camera
	camera_over_player.position = player.position

func update_progress_bar_energy() -> void:
	game_interface.progress_bar_energy.value = player.energy

func update_player_stats() -> void:
	player.energy = 10
	update_progress_bar_energy()

	# reset to player
	hexa_tile_set.clear_selected_walkable_tiles()
	hexa_tile_set.cell_action(hexa_tile_layer_0.local_to_map(player.position), true, false)