extends Node
const STORE = preload("res://scripts/systems/world_save.gd")
const SCENES = ["res://scenes/levels/world_1_1.tscn","res://scenes/levels/world_1_2.tscn","res://scenes/levels/world_1_3.tscn","res://scenes/levels/world_1_guardian.tscn"]
var store = STORE.new()
var scene_paths: Array = SCENES.duplicate()
var level: Node2D
var data: Dictionary
var save_enabled := true
var _last_save := ""
var _changing := false

func fresh() -> Dictionary:
	return {"save_version":1,"stage":0,"unlocked":0,"finished":false,"levels":{},"settings":{"music":true,"effects":true}}

func _ready() -> void:
	data = _read_progress()
	_load_stage(int(data.stage))

func _read_progress() -> Dictionary:
	data = store.read_save() if save_enabled else {}
	if data.is_empty():
		data = fresh()
		# Importa somente as preferências, nunca marca fases novas como concluídas.
		if save_enabled:
			var previous = preload("res://scripts/systems/save_manager.gd").new().read_save()
			if previous.has("settings"): data.settings = previous.settings.duplicate()
	return data

func _load_stage(index: int) -> void:
	get_tree().paused = false
	for action in ["move_left","move_right","move_down","jump","action","switch_character"]: Input.action_release(action)
	if is_instance_valid(level):
		remove_child(level)
		level.queue_free()
	data.stage = index
	level = load(scene_paths[index]).instantiate()
	level.campaign = self
	level.music_enabled = data.settings.music
	level.effects_enabled = data.settings.effects
	add_child(level)
	_restore_level(data.levels.get(str(index),{}))
	level._apply_audio()
	_changing = false
	save_progress()

func _restore_level(state: Dictionary) -> void:
	if not state.is_empty(): level.restore_world(state)

func _capture_level() -> Dictionary:
	return level.world_snapshot()

func _prepare_save() -> void:
	pass

func save_progress() -> void:
	if not is_instance_valid(level) or not level.world_ready: return
	data.levels[str(data.stage)] = _capture_level()
	data.settings = {"music":level.music_enabled,"effects":level.effects_enabled}
	if level.completed:
		data.unlocked = maxi(data.unlocked,mini(data.stage+1,scene_paths.size()-1))
		if data.stage == scene_paths.size()-1: data.finished = true
	_prepare_save()
	var encoded := JSON.stringify(data)
	if save_enabled and encoded != _last_save and store.write_save(data): _last_save = encoded
	if is_instance_valid(level.save_label):
		level.save_label.text = ("Progresso salvo • Mundo %d" % (int(data.stage)/4+1)) if store.state == "saved" else "Aventura • Progresso local"
		if store.state == "unavailable": level.save_label.text = "Não foi possível salvar neste dispositivo"
		elif store.locked: level.save_label.text = "Save não reconhecido • Recomeçar cria outro"

func advance() -> void:
	if _changing or not level.completed or data.stage >= scene_paths.size()-1: return
	save_progress()
	_changing = true
	_load_stage.call_deferred(int(data.stage)+1)

func new_adventure() -> void:
	if _changing: return
	_changing = true
	var settings: Dictionary = data.settings.duplicate()
	data = fresh()
	data.settings = settings
	store.locked = false
	_last_save = ""
	_load_stage.call_deferred(0)
