extends TileMapLayer
class_name HexaTileLayer

@export var tile_layer = 0


# cell is clicked
signal cell_action

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event) -> void:

	# on mouse event
	if Global.mouse_in_game and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			cell_action.emit(local_to_map(get_local_mouse_position()), true, false)

		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			cell_action.emit(local_to_map(get_local_mouse_position()), false, false)
