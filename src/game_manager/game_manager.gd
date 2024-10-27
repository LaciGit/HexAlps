extends Node
class_name GameManager

# Player
## resources
var path_player: PackedScene = preload("res://scenes/characters/player.tscn")
var player: Player = null

# starting hex for player

func _ready() -> void:


    if not player:
        var tmp_player = path_player.instantiate()
