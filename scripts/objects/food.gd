extends "res://scripts/objects/nut.gd"
@export_enum("Maçã", "Frutas silvestres", "Cenoura") var food_kind: int = 0
@export_range(1,9) var food_value := 1

func _init() -> void:
	collectible_kind = "food"
