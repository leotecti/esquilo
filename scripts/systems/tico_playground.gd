extends Node2D

@onready var tico: CharacterBody2D = $Tico
@onready var camera: Camera2D = $FollowCamera
@onready var pause_button: Button = $Interface/HUD/TopBar/Pause
@onready var status: Label = $Interface/HUD/Status


func _ready() -> void:
	$Interface/HUD/TopBar/Restart.pressed.connect(restart)
	pause_button.pressed.connect(toggle_pause)
	tico.reset_at($PlayerSpawn.global_position)
	camera.snap_to_target()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and is_node_ready():
		set_paused(true)


func set_paused(value: bool) -> void:
	get_tree().paused = value
	pause_button.text = "Continuar (Esc)" if value else "Pausar (Esc)"
	# Evita movimento preso ao trocar de janela com uma tecla pressionada.
	if value:
		for action in ["move_left", "move_right", "jump"]:
			Input.action_release(action)


func toggle_pause() -> void:
	set_paused(not get_tree().paused)


func restart() -> void:
	set_paused(false)
	for action in ["move_left", "move_right", "jump"]:
		Input.action_release(action)
	tico.reset_at($PlayerSpawn.global_position)
	camera.snap_to_target()


func _process(_delta: float) -> void:
	if get_tree().paused:
		status.text = "PAUSADO · Esc ou Continuar para voltar"
	else:
		var names := {&"idle": "Parado", &"run": "Correndo", &"jump": "Subindo",
			&"fall": "Caindo", &"glide": "Planando", &"land": "Aterrissando"}
		status.text = "%s · Cauda: %.1f s" % [names.get(tico.state, ""), tico.glide_remaining]
	if tico.position.y > 1100.0:
		restart()
