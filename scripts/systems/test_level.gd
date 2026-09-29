extends Node2D
## Instrumentação visível somente na área de teste da fundação técnica.

@onready var probe: CharacterBody2D = $TestProbe
@onready var status: Label = $Interface/Panel/Status
var last_command: String = "Nenhum"


func _ready() -> void:
	probe.global_position = $PlayerSpawn.global_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("action"):
		last_command = "E / action"
	elif event.is_action_pressed("switch_character"):
		last_command = "Q / switch_character"


func _process(_delta: float) -> void:
	var state := "NO AR"
	if probe.is_on_floor():
		state = "NO CHÃO"
	if get_tree().paused:
		state = "PAUSADO — Esc para continuar"
	status.text = "%s  |  Último comando: %s" % [state, last_command]
