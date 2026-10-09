extends Node
## Reduz callbacks distantes em fases longas sem remover colisões ou estado.
const OBJECT_ART = preload("res://scripts/presentation/object_art.gd")
const ENEMY_ART = preload("res://scripts/presentation/enemy_art.gd")
const TRAVEL_PLATFORM = preload("res://scripts/objects/travel_platform.gd")
const CARRYABLE_SUPPLY = preload("res://scripts/objects/carryable_supply.gd")
const UPDATE_INTERVAL := 0.18
const VISUAL_RANGE_X := 1180.0
const VISUAL_RANGE_Y := 900.0
const ENEMY_RANGE_X := 1650.0
const ENEMY_RANGE_Y := 1050.0

var level: Node2D
var _elapsed := UPDATE_INTERVAL
var _visuals: Array[Node] = []
var _enemies: Array[Node] = []
var _moving_objects: Array[Node] = []
var active_visuals := 0
var active_enemies := 0
var active_moving_objects := 0

func _ready() -> void:
	process_priority = -80
	refresh_registry()
	_update_activity()

func refresh_registry() -> void:
	_visuals.clear()
	_enemies.clear()
	_moving_objects.clear()
	if not is_instance_valid(level) or not is_instance_valid(level.actors): return
	for actor in level.actors.get_children():
		if actor.get_script() in [TRAVEL_PLATFORM,CARRYABLE_SUPPLY]: _moving_objects.append(actor)
		if actor.has_method("reset_enemy") and actor.get_node_or_null("EnemyArt"):
			_enemies.append(actor)
		for child in actor.get_children():
			if child.get_script() in [OBJECT_ART,ENEMY_ART]: _visuals.append(child)

func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed<UPDATE_INTERVAL: return
	_elapsed = 0.0
	_update_activity()

func _update_activity() -> void:
	if not is_instance_valid(level) or not is_instance_valid(level.tico): return
	var player_position: Vector2 = level.tico.global_position
	active_visuals = 0
	for visual in _visuals:
		if not is_instance_valid(visual): continue
		var parent := visual.get_parent() as Node2D
		var active := is_instance_valid(parent) and parent.visible and absf(parent.global_position.x-player_position.x)<VISUAL_RANGE_X and absf(parent.global_position.y-player_position.y)<VISUAL_RANGE_Y
		visual.set_process(active)
		if active:
			active_visuals += 1
			visual.queue_redraw()
	active_enemies = 0
	for enemy in _enemies:
		if not is_instance_valid(enemy): continue
		var enemy_node := enemy as Node2D
		var active: bool = enemy_node.visible and absf(enemy_node.global_position.x-player_position.x)<ENEMY_RANGE_X and absf(enemy_node.global_position.y-player_position.y)<ENEMY_RANGE_Y
		enemy.set_physics_process(active)
		if active: active_enemies += 1
	active_moving_objects = 0
	for object in _moving_objects:
		if not is_instance_valid(object): continue
		var object_node := object as Node2D
		var force_active := false
		if object.get_script()==CARRYABLE_SUPPLY:
			force_active = object.carried or object.placing or object.departing
		var active := force_active or (object_node.visible and absf(object_node.global_position.x-player_position.x)<ENEMY_RANGE_X and absf(object_node.global_position.y-player_position.y)<ENEMY_RANGE_Y)
		object.set_process(active)
		object.set_physics_process(active)
		if active: active_moving_objects += 1

func details() -> Dictionary:
	return {"tracked_visuals":_visuals.size(),"active_visuals":active_visuals,
		"tracked_enemies":_enemies.size(),"active_enemies":active_enemies,
		"tracked_moving_objects":_moving_objects.size(),"active_moving_objects":active_moving_objects,
		"update_interval":UPDATE_INTERVAL}
