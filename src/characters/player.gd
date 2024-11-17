extends Node2D
class_name Player


@export var energy: int = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_player(selected_walkable_tiles: Array, movement_done: int) -> void:
	"""move player to selected walkable tiles
	:param selected_walkable_tiles: Array of selected walkable tiles Array[Vector2]
	:param movement_done: movement done which gets subtracted from energy
	"""

	if movement_done > energy:
		print("not enough energy")
		return
	else:
		energy -= movement_done

	if selected_walkable_tiles.size() == 0:
		print("no walkable tiles selected")
		return
	elif selected_walkable_tiles.size() == 1:
		position = selected_walkable_tiles[0]
		return
	else:
		print("Ups... multiple walkable tiles selected!")
