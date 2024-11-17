extends Node
class_name PlayerStats

@export var default_health: int = 10
@export var default_energy: int = 10
@export var default_mana: int = 10

var energy: int = -10
var health: int = -10
var mana: int = -10

enum NAMES {HEALTH, ENERGY, MANA}

func _init() -> void:
    # active stats
    energy = default_energy
    health = default_health
    mana = default_mana


func update_stat(stat: NAMES, value: int) -> void:
    """
    :param stat: stat to update
    :param value: value to update
    """

    var current_value: int = 0

    match stat:
        NAMES.HEALTH:
            current_value = health
        NAMES.ENERGY:
            current_value = energy
        NAMES.MANA:
            current_value = mana

    if value < 0 and value > current_value:
        # do not allow to increase stats
        return
    else:
        current_value += value

    match stat:
        NAMES.HEALTH:
            health = current_value
        NAMES.ENERGY:
            energy = current_value
        NAMES.MANA:
            mana = current_value

func reset_stats() -> void:
    """
    reset all stats to default
    """
    health = default_health
    energy = default_energy
    mana = default_mana
