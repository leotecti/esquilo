extends CanvasLayer
## Localizador temporário para playtests. Oculto por padrão e sem persistência.
var level: Node2D
var panel: PanelContainer
var readout: Label
var copy_button: Button
var hint: Label
var visible_mode := false
var _tap_count := 0
var _last_tap_msec := 0
var _last_text := ""
var last_copied := ""

func _ready() -> void:
	layer = 48
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	set_process_input(true)
	set_process(false)
	_update_layout()

func _build_ui() -> void:
	panel = PanelContainer.new()
	panel.name = "LocationDiagnostic"
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	var style := StyleBoxFlat.new()
	style.bg_color = Color("18352fec")
	style.border_color = Color("e5b85d")
	style.set_border_width_all(2)
	style.set_corner_radius_all(14)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel",style)
	add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation",7)
	panel.add_child(column)
	readout = Label.new()
	readout.name = "Readout"
	readout.add_theme_font_size_override("font_size",17)
	readout.add_theme_color_override("font_color",Color("fff2d3"))
	readout.add_theme_color_override("font_outline_color",Color("0b201b"))
	readout.add_theme_constant_override("outline_size",3)
	column.add_child(readout)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation",8)
	column.add_child(row)
	copy_button = Button.new()
	copy_button.name = "CopyLocation"
	copy_button.text = "Copiar localização"
	copy_button.custom_minimum_size = Vector2(190,44)
	copy_button.add_theme_font_size_override("font_size",16)
	copy_button.pressed.connect(copy_location)
	row.add_child(copy_button)
	hint = Label.new()
	hint.text = "F3 para ocultar"
	hint.add_theme_font_size_override("font_size",14)
	hint.add_theme_color_override("font_color",Color("d6e5c8"))
	hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(hint)
	panel.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode==KEY_F3:
		toggle()
		get_viewport().set_input_as_handled()
	elif event is InputEventScreenTouch and event.pressed and _title_contains(event.position):
		_register_title_tap(Time.get_ticks_msec())

func _title_contains(point: Vector2) -> bool:
	if not is_instance_valid(level): return false
	var title := level.get_node_or_null("Interface/HUD/TopBar/Title") as Control
	return is_instance_valid(title) and title.get_global_rect().grow(10).has_point(point)

func _register_title_tap(now_msec: int) -> void:
	if now_msec-_last_tap_msec>700: _tap_count = 0
	_tap_count += 1
	_last_tap_msec = now_msec
	if _tap_count>=3:
		_tap_count = 0
		toggle()

func toggle(force: Variant = null) -> void:
	visible_mode = not visible_mode if force == null else bool(force)
	panel.visible = visible_mode
	set_process(visible_mode)
	if visible_mode:
		refresh()
		_update_layout()

func _process(_delta: float) -> void:
	if not visible_mode or not is_instance_valid(level) or not is_instance_valid(level.tico): return
	var current := location_text()
	if current!=_last_text:
		_last_text = current
		readout.text = current.replace(" | ","\n")

func refresh() -> void:
	_last_text = ""
	_process(0)

func phase_name() -> String:
	if level.get("biome")!=null and level.get("section")!=null:
		return "%d-%d" % [int(level.biome),int(level.section)+1]
	if level.get("world_stage")!=null:
		return "1-%d" % (int(level.world_stage)+1)
	var title := level.get_node_or_null("Interface/HUD/TopBar/Title") as Label
	return title.text.get_slice("\n",0) if is_instance_valid(title) else "Fase"

func area_name() -> String:
	if is_instance_valid(level.get("optional_area")) and level.optional_area.active:
		if level.get("biome")!=null and int(level.biome)==2 and int(level.section)==1:
			return "Túnel das Raízes"
		if level.get("biome")!=null and int(level.biome)==2 and int(level.section)==2:
			return "Galeria da Tempestade"
		match int(level.get("world_stage")):
			0: return "Copa dos Segredos"
			1: return "Galeria das Pedras"
			2: return "Gruta Fria"
	if level.get("biome")!=null and int(level.biome)==3 and int(level.section)==1:
		return "Cavernas da Montanha"
	return "Trilha principal"

func segment_name() -> String:
	var x: float = level.tico.global_position.x
	var start := 0.0
	var span := 3200.0
	if is_instance_valid(level.get("optional_area")) and level.optional_area.active:
		match int(level.get("world_stage")):
			0: start = 60000.0; span = 800.0
			1: start = 46000.0; span = 900.0
			2: start = 65000.0; span = 900.0
	return "T%02d" % (maxi(0,int(floor((x-start)/span)))+1)

func location_text() -> String:
	if not is_instance_valid(level) or not is_instance_valid(level.tico): return "Localização indisponível"
	var point: Vector2 = level.tico.global_position
	return "Fase %s | %s | %s | X %d | Y %d" % [phase_name(),area_name(),segment_name(),roundi(point.x),roundi(point.y)]

func copy_location() -> void:
	var text := location_text()
	last_copied = text
	DisplayServer.clipboard_set(text)
	copy_button.text = "Copiado!"
	get_tree().create_timer(1.2,true,false,true).timeout.connect(func():
		if is_instance_valid(copy_button): copy_button.text = "Copiar localização")

func _update_layout() -> void:
	if not is_instance_valid(panel): return
	var viewport := get_viewport().get_visible_rect().size
	panel.size = Vector2(310,168)
	panel.position = Vector2(viewport.x-panel.size.x-18,100)
