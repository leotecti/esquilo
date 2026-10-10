extends CanvasLayer

signal closed

const DIAGRAM = preload("res://scripts/ui/controller_diagram.gd")
const ACTION_LABELS := {
	&"jump": "Pular e planar",
	&"action": "Ação, caudada e investida",
	&"switch_character": "Trocar Tico / Pipo",
	&"pause": "Pausar o jogo",
}

var level: Node
var panel: PanelContainer
var diagram: Control
var status: Label
var device_label: Label
var action_buttons: Dictionary = {}
var awaiting: StringName = &""


func _ready() -> void:
	layer = 70
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build()
	hide()
	get_viewport().size_changed.connect(_layout)
	Input.joy_connection_changed.connect(_on_connection_changed)


func _build() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.035, 0.10, 0.075, 0.93)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	panel = PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _box(Color("f7ecd2"), Color("9db67c"), 28))
	add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)
	var title := Label.new()
	title.text = "Configurar controle"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color("294b38"))
	content.add_child(title)
	device_label = Label.new()
	device_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	device_label.add_theme_font_size_override("font_size", 15)
	device_label.add_theme_color_override("font_color", Color("57705c"))
	content.add_child(device_label)
	diagram = DIAGRAM.new()
	diagram.custom_minimum_size = Vector2(520, 220)
	diagram.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(diagram)
	var fixed := Label.new()
	fixed.text = "Direcional / analógico esquerdo: movimentar e descer"
	fixed.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fixed.add_theme_font_size_override("font_size", 16)
	fixed.add_theme_color_override("font_color", Color("365b43"))
	content.add_child(fixed)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 6)
	content.add_child(grid)
	for action in ControllerProfile.REMAPPABLE:
		var label := Label.new()
		label.text = ACTION_LABELS[action]
		label.custom_minimum_size.x = 310
		label.add_theme_font_size_override("font_size", 17)
		label.add_theme_color_override("font_color", Color("294b38"))
		grid.add_child(label)
		var button := Button.new()
		button.custom_minimum_size = Vector2(250, 42)
		_style_button(button)
		button.pressed.connect(_begin_capture.bind(action))
		grid.add_child(button)
		action_buttons[action] = button
	status = Label.new()
	status.text = "Selecione uma ação para trocar seu botão."
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_font_size_override("font_size", 15)
	status.add_theme_color_override("font_color", Color("75552d"))
	content.add_child(status)
	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_CENTER
	footer.add_theme_constant_override("separation", 16)
	content.add_child(footer)
	var restore := Button.new()
	restore.text = "Restaurar padrão"
	restore.custom_minimum_size = Vector2(220, 46)
	_style_button(restore)
	restore.pressed.connect(_restore)
	footer.add_child(restore)
	var back := Button.new()
	back.text = "Voltar"
	back.custom_minimum_size = Vector2(220, 46)
	_style_button(back)
	back.pressed.connect(close)
	footer.add_child(back)


func open() -> void:
	awaiting = &""
	_refresh()
	show()
	_layout()
	var first: Button = action_buttons[ControllerProfile.REMAPPABLE[0]]
	first.grab_focus()


func close() -> void:
	awaiting = &""
	hide()
	closed.emit()


func _begin_capture(action: StringName) -> void:
	awaiting = action
	status.text = "Pressione agora o botão para: %s" % ACTION_LABELS[action]
	for button in action_buttons.values():
		button.disabled = true


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if awaiting != &"" and event is InputEventJoypadButton and event.pressed:
		ControllerProfile.assign(awaiting, event.button_index)
		awaiting = &""
		status.text = "Configuração salva."
		_refresh()
		get_viewport().set_input_as_handled()
	elif awaiting == &"" and event.is_action_pressed("pause"):
		close()
		get_viewport().set_input_as_handled()


func _refresh() -> void:
	for action in ControllerProfile.REMAPPABLE:
		var button: Button = action_buttons[action]
		button.disabled = false
		button.text = ControllerProfile.button_name(int(ControllerProfile.bindings[action]))
	diagram.update_bindings(ControllerProfile.bindings)
	_update_device()


func _restore() -> void:
	ControllerProfile.restore_defaults()
	status.text = "Configuração padrão restaurada."
	_refresh()


func _on_connection_changed(_device: int, _connected: bool) -> void:
	if visible:
		_update_device()


func _update_device() -> void:
	var devices := Input.get_connected_joypads()
	device_label.text = "Controle conectado: %s" % Input.get_joy_name(devices[0]) if not devices.is_empty() else "Nenhum controle detectado neste momento"


func _layout() -> void:
	if not is_instance_valid(panel):
		return
	var view := get_viewport().get_visible_rect().size
	var target := Vector2(minf(720.0, view.x - 36.0), minf(680.0, view.y - 24.0))
	panel.size = target
	panel.position = (view - target) * 0.5


func _style_button(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _box(Color("31543e"), Color("88a16a"), 14))
	button.add_theme_stylebox_override("hover", _box(Color("466e49"), Color("d9ca83"), 14))
	button.add_theme_stylebox_override("pressed", _box(Color("93612e"), Color("f3cb70"), 14))
	button.add_theme_stylebox_override("disabled", _box(Color("758276"), Color("9da493"), 14))
	button.add_theme_stylebox_override("focus", _box(Color("31543e"), Color("e7b956"), 14))
	button.add_theme_color_override("font_color", Color("fff1ce"))
	button.add_theme_font_size_override("font_size", 16)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _box(color: Color, border: Color, radius: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = border
	box.set_border_width_all(2)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 18
	box.content_margin_right = 18
	box.content_margin_top = 10
	box.content_margin_bottom = 10
	return box
