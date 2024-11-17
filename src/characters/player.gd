extends Node2D
class_name Player


signal update_player_stats_on_ui(player_stats: PlayerStats)


var player_stats: PlayerStats = PlayerStats.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_energy() -> void:
	player_stats.reset_stats()
	update_player_stats_on_ui.emit(player_stats)

func move_player(selected_walkable_tiles: Array, movement_done: int) -> void:
	"""move player to selected walkable tiles
	:param selected_walkable_tiles: Array of selected walkable tiles Array[Vector2]
	:param movement_done: movement done which gets subtracted from energy
	"""

	if movement_done > player_stats.energy:
		print("not enough energy")
		return

	player_stats.update_stat(PlayerStats.NAMES.ENERGY, -movement_done)
	update_player_stats_on_ui.emit(player_stats)

	# TODO: still fuzzy because I did not decide if user can draw path or move one by one
	if selected_walkable_tiles.size() == 0:
		print("no walkable tiles selected")
		return
	elif selected_walkable_tiles.size() == 1:
		position = selected_walkable_tiles[0]
		return
	else:
		print("Ups... multiple walkable tiles selected!")
