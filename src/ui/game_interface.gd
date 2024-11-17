extends Control
class_name GameInterface


# Signals
signal next_turn

@onready var next_turn_button: Button = %NextTurnButton
@onready var progress_bar_energy: ProgressBar = %ProgressBarEnergy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_turn_button_pressed() -> void:
	next_turn.emit()

func _on_next_turn_button_mouse_entered() -> void:
	# when mouse enters ui we are not in game anymore
	Global.mouse_in_game = false


func _on_next_turn_button_mouse_exited() -> void:
	# when mouse exits ui we are in game
	Global.mouse_in_game = true
