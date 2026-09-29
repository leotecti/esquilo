extends Node2D

@onready var tico: CharacterBody2D = $Tico
@onready var camera: Camera2D = $FollowCamera
@onready var pause_button: Button = $Interface/HUD/TopBar/Pause
@onready var status: Label = $Interface/HUD/Status
@onready var touch: Control = $Interface/HUD/TouchControls
var _browser_test: bool = false
var _snapshot_time: float = 0.0


func _ready() -> void:
	$Interface/HUD/TopBar/Restart.pressed.connect(restart)
	pause_button.pressed.connect(toggle_pause)
	tico.reset_at($PlayerSpawn.global_position)
	camera.snap_to_target()
	get_viewport().size_changed.connect(_update_layout)
	touch.touch_detected.connect(_update_layout)
	if OS.has_feature("web"):
		_browser_test = bool(JavaScriptBridge.eval("new URLSearchParams(location.search).get('test') === '1'"))
	_update_layout()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and is_node_ready():
		set_paused(true)


func set_paused(value: bool) -> void:
	get_tree().paused = value
	pause_button.text = "Continuar" if value else "Pausar"
	touch.set_controls_active(not value)
	# Evita movimento preso ao trocar de janela com uma tecla pressionada.
	if value:
		for action in ["move_left", "move_right", "jump", "action"]:
			Input.action_release(action)


func toggle_pause() -> void:
	set_paused(not get_tree().paused)


func restart() -> void:
	set_paused(false)
	touch.release_all()
	for action in ["move_left", "move_right", "jump"]:
		Input.action_release(action)
	tico.reset_at($PlayerSpawn.global_position)
	camera.snap_to_target()


func _update_layout() -> void:
	touch.update_layout()
	var inset: Vector4 = touch.safe_insets()
	var bar: HBoxContainer = $Interface/HUD/TopBar
	bar.offset_left = 32.0 + inset.x
	bar.offset_right = -32.0 - inset.z
	bar.offset_top = 20.0 + inset.y
	$Interface/HUD/Instructions.visible = not touch.touch_enabled
	pause_button.text = "Continuar" if get_tree().paused else "Pausar"
	var jump_name: String = "PULO" if touch.touch_enabled else "Espaço"
	$Signs/Walk.text = "1 · Explore com calma\nUse as setas para correr." if touch.touch_enabled else "1 · Explore com calma\nA/D ou setas para correr."
	$Signs/Jump.text = "2 · Pule mais alto\nSegure %s na subida." % jump_name
	$Signs/Glide.text = "3 · Abra a cauda!\nSegure %s durante a queda." % jump_name
	$Signs/Ceiling.text = "4 · Salto curto\nSolte %s mais cedo." % jump_name
	bar.offset_bottom = bar.offset_top + (88.0 if touch.touch_enabled else 44.0)
	for button in [pause_button, $Interface/HUD/TopBar/Restart]:
		button.custom_minimum_size.y = 88.0 if touch.touch_enabled else 44.0
	status.offset_left = 32.0 + inset.x
	status.offset_top = bar.offset_bottom + 10.0 if touch.touch_enabled else 108.0
	if touch.is_portrait():
		set_paused(true)


func _process(_delta: float) -> void:
	if _browser_test:
		_snapshot_time += _delta
		if _snapshot_time >= 0.1:
			_snapshot_time = 0.0
			var buttons: Dictionary = {}
			for button in touch.get_children():
				buttons[str(button.name)] = [button.position.x, button.position.y, 128, 128]
			var snapshot: Dictionary = {"x": tico.position.x, "y": tico.position.y,
				"state": str(tico.state), "paused": get_tree().paused,
				"touch": touch.visible, "width": get_viewport_rect().size.x,
				"height": get_viewport_rect().size.y, "buttons": buttons,
				"right": Input.is_action_pressed("move_right"),
				"jump": Input.is_action_pressed("jump"), "action": Input.is_action_pressed("action")}
			snapshot.merge(_test_details())
			JavaScriptBridge.eval("window.__ticoTest = " + JSON.stringify(snapshot))
	if get_tree().paused:
		status.text = "PAUSADO · Esc ou Continuar para voltar"
	else:
		var names := {&"idle": "Parado", &"run": "Correndo", &"jump": "Subindo",
			&"fall": "Caindo", &"glide": "Planando", &"land": "Aterrissando"}
		status.text = "%s · Cauda: %.1f s" % [names.get(tico.state, ""), tico.glide_remaining]
	if tico.position.y > 1100.0:
		restart()


func _test_details() -> Dictionary:
	return {}
