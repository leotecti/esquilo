extends Camera2D
## Acompanha um personagem, com suavização e antecipação na direção do movimento.

@export var target_path: NodePath
@export var look_ahead: float = 110.0
@export var look_response: float = 4.0
@export var vertical_offset: float = -95.0
var _look: float = 0.0
@onready var target: CharacterBody2D = get_node(target_path)


func _ready() -> void:
	global_position = target.global_position + Vector2(0.0, vertical_offset)
	reset_smoothing()


func _physics_process(delta: float) -> void:
	var wanted := 0.0
	if absf(target.velocity.x) > 10.0:
		wanted = signf(target.velocity.x) * look_ahead
	_look = lerpf(_look, wanted, 1.0 - exp(-look_response * delta))
	global_position = target.global_position + Vector2(_look, vertical_offset)


func snap_to_target() -> void:
	_look = 0.0
	global_position = target.global_position + Vector2(0.0, vertical_offset)
	reset_smoothing()
	force_update_scroll()
