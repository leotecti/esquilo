extends "res://scripts/systems/world_campaign.gd"
var legacy_path := "user://world1.json"

func _init() -> void:
	store = preload("res://scripts/systems/expedition_save.gd").new()
	for world in range(2,5):
		for section in ["1","2","3","guardian"]:
			scene_paths.append("res://scenes/levels/world_%d_%s.tscn" % [world,section])

func _read_progress() -> Dictionary:
	var saved: Dictionary = store.read_save() if save_enabled else {}
	if not saved.is_empty(): return saved
	if save_enabled and store.state=="empty":
		var legacy = preload("res://scripts/systems/world_save.gd").new()
		legacy.path = legacy_path
		var previous: Dictionary = legacy.read_save()
		if not previous.is_empty():
			previous = previous.duplicate(true)
			if previous.finished: previous.unlocked = 4
			previous.finished = false
			return previous
	# Não substitui campanha danificada por uma cópia antiga.
	var result := fresh()
	if save_enabled and store.state=="empty":
		var prototype: Dictionary = preload("res://scripts/systems/save_manager.gd").new().read_save()
		if prototype.has("settings"): result.settings = prototype.settings.duplicate()
	return result
