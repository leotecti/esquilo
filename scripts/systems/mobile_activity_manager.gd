extends Node
## Reduz callbacks distantes em fases longas sem remover colisões ou estado.
const OBJECT_ART = preload("res://scripts/presentation/object_art.gd")
const ENEMY_ART = preload("res://scripts/presentation/enemy_art.gd")
const TRAVEL_PLATFORM = preload("res://scripts/objects/travel_platform.gd")
const CARRYABLE_SUPPLY = preload("res://scripts/objects/carryable_supply.gd")
const PERFORMANCE_PROFILE_VERSION := 2
const UPDATE_INTERVAL := 0.24
const VISUAL_RANGE_X := 1020.0
const VISUAL_RANGE_Y := 820.0
const ENEMY_RANGE_X := 1380.0
const ENEMY_RANGE_Y := 920.0
const COLLECTIBLE_RANGE_X := 1120.0
const COLLECTIBLE_RANGE_Y := 900.0

var level: Node2D
var _elapsed := UPDATE_INTERVAL
var _visuals: Array[Node] = []
var _enemies: Array[Node] = []
var _moving_objects: Array[Node] = []
var _collectibles: Array[Node] = []
var active_visuals := 0
var active_enemies := 0
var active_moving_objects := 0
var active_collectibles := 0

func _ready() -> void:
	process_priority = -80
	refresh_registry()
	_update_activity()

func refresh_registry() -> void:
	_visuals.clear()
	_enemies.clear()
	_moving_objects.clear()
	_collectibles.clear()
	if not is_instance_valid(level) or not is_instance_valid(level.actors): return
	for actor in level.actors.get_children():
		if actor.get_script() in [TRAVEL_PLATFORM,CARRYABLE_SUPPLY]: _moving_objects.append(actor)
		if actor.has_method("reset_item") and actor is Area2D: _collectibles.append(actor)
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
	active_collectibles = 0
	for collectible in _collectibles:
		if not is_instance_valid(collectible): continue
		var item := collectible as Node2D
		var active: bool = item.visible and absf(item.global_position.x-player_position.x)<COLLECTIBLE_RANGE_X and absf(item.global_position.y-player_position.y)<COLLECTIBLE_RANGE_Y
		# Sinais de Area2D continuam baratos quando próximos; itens distantes não
		# precisam consultar sobreposição de coração nem participar do broadphase.
		collectible.set_physics_process(active)
		collectible.set_deferred("monitoring",active)
		if active: active_collectibles += 1

func details() -> Dictionary:
	return {"tracked_visuals":_visuals.size(),"active_visuals":active_visuals,
		"tracked_enemies":_enemies.size(),"active_enemies":active_enemies,
		"tracked_moving_objects":_moving_objects.size(),"active_moving_objects":active_moving_objects,
		"tracked_collectibles":_collectibles.size(),"active_collectibles":active_collectibles,
		"update_interval":UPDATE_INTERVAL,"profile_version":PERFORMANCE_PROFILE_VERSION}
