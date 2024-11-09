extends Node
class_name GameManager

# Tilemap
@export var hexa_tile_layer_0: HexaTileLayer

# Player
## resources
var path_player: PackedScene = preload("res://scenes/characters/player.tscn")
var player: Player = null

# starting hex for player

func _ready() -> void:
	if not player:
		var tmp_player = path_player.instantiate()
		var local_map_pos = hexa_tile_layer_0.map_to_local(Vector2i(0, 0))
		tmp_player.position = local_map_pos
		add_child(tmp_player)
