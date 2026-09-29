extends Control
signal touch_detected
## Multitoque usa as mesmas ações de teclado; não altera o controlador de Tico.

@export var force_visible: bool = false
var touch_enabled: bool = false
var _buttons: Dictionary = {}
var _portrait: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	touch_enabled = force_visible or DisplayServer.is_touchscreen_available()
	for binding in [["Left", "move_left", "◀"], ["Right", "move_right", "▶"],
		["Jump", "jump", "PULO"], ["Action", "action", "AÇÃO"]]:
		var button := TouchScreenButton.new()
		button.name = binding[0]
		button.action = binding[1]
		button.texture_normal = preload("res://assets/ui/touch_normal.svg")
		button.texture_pressed = preload("res://assets/ui/touch_pressed.svg")
		var hit_shape := RectangleShape2D.new()
		hit_shape.size = Vector2(128, 128)
		button.shape = hit_shape
		button.passby_press = binding[0] in ["Left", "Right"]
		var caption := Label.new()
		caption.text = binding[2]
		if binding[0] in ["Left", "Right"]:
			caption.text = ""
			var arrow := Polygon2D.new()
			arrow.polygon = PackedVector2Array([Vector2(80, 38), Vector2(42, 64), Vector2(80, 90)])
			arrow.color = Color("fff3d9")
			if binding[0] == "Right":
				arrow.position.x = 128
				arrow.scale.x = -1
			button.add_child(arrow)
		caption.size = Vector2(128, 128)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		caption.add_theme_font_size_override("font_size", 27)
		caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(caption)
		add_child(button)
		_buttons[binding[0]] = button
	get_viewport().size_changed.connect(update_layout)
	update_layout()


func _input(event: InputEvent) -> void:
	# Alguns navegadores só anunciam touch depois do primeiro contato.
	if event is InputEventScreenTouch and not touch_enabled:
		touch_enabled = true
		update_layout()
		touch_detected.emit()


func safe_insets() -> Vector4:
	if OS.has_feature("web"):
		var value = JavaScriptBridge.eval("window.ticoSafeInsets ? JSON.stringify(window.ticoSafeInsets()) : '[0,0,0,0]'")
		var values = JSON.parse_string(str(value))
		if values is Array and values.size() == 4:
			var css_width := float(JavaScriptBridge.eval("window.innerWidth"))
			var ratio := get_viewport_rect().size.x / maxf(css_width, 1.0)
			return Vector4(values[0], values[1], values[2], values[3]) * ratio
	return Vector4.ZERO


func update_layout() -> void:
	var viewport_size := get_viewport_rect().size
	var inset := safe_insets()
	var y := viewport_size.y - 150.0 - inset.w
	_buttons["Left"].position = Vector2(32.0 + inset.x, y)
	_buttons["Right"].position = Vector2(180.0 + inset.x, y)
	_buttons["Jump"].position = Vector2(viewport_size.x - 160.0 - inset.z, y)
	_buttons["Action"].position = Vector2(viewport_size.x - 308.0 - inset.z, y)
	_portrait = touch_enabled and viewport_size.y > viewport_size.x
	set_controls_active(not get_tree().paused)


func set_controls_active(active: bool) -> void:
	visible = touch_enabled and active and not _portrait
	if not visible:
		release_all()


func release_all() -> void:
	# Ocultar cada botão libera seu dedo interno e impede reativação após pausa.
	for button in _buttons.values():
		button.hide()
		Input.action_release(button.action)
		button.show()


func is_portrait() -> bool:
	return _portrait
