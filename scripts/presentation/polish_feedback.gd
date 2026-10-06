extends CanvasLayer
## Resposta visual compartilhada pelos eventos importantes da aventura.
var level: Node2D
var flash: ColorRect
var banner: Label
var _flash_tween: Tween
var _banner_tween: Tween
var events: Dictionary = {}

func _ready() -> void:
	layer = 17
	flash = ColorRect.new()
	flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash.modulate.a = 0.0
	add_child(flash)
	banner = Label.new()
	banner.position = Vector2(390,125)
	banner.size = Vector2(500,54)
	banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	banner.add_theme_font_size_override("font_size",25)
	banner.add_theme_color_override("font_color",Color("fff4cf"))
	banner.add_theme_color_override("font_outline_color",Color("294638"))
	banner.add_theme_constant_override("outline_size",7)
	banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	banner.modulate.a = 0.0
	add_child(banner)

func react(kind: String, text := "") -> void:
	events[kind] = int(events.get(kind,0))+1
	var colors := {"hurt":Color("c94f4f"),"defeat":Color("49384f"),"life":Color("f6d66f"),
		"secret":Color("8fd8b2"),"checkpoint":Color("f4e2a0"),"victory":Color("fff0ad"),
		"boss":Color("e39a62"),"unlock":Color("b8e58b")}
	flash.color = colors.get(kind,Color("fff4d7"))
	if is_instance_valid(_flash_tween): _flash_tween.kill()
	flash.modulate.a = 0.0
	_flash_tween = create_tween()
	_flash_tween.tween_property(flash,"modulate:a",.16 if kind not in ["hurt","defeat"] else .24,.06)
	_flash_tween.tween_property(flash,"modulate:a",0.0,.24)
	if kind in ["hurt","defeat","boss"]: _shake(7.0 if kind=="boss" else 4.0)
	if not text.is_empty(): _show_banner(text)

func _shake(strength: float) -> void:
	if not is_instance_valid(level) or not is_instance_valid(level.camera): return
	var camera: Camera2D = level.camera
	var tween := create_tween()
	for offset in [Vector2(strength,-strength*.5),Vector2(-strength*.7,strength*.4),Vector2(strength*.35,0),Vector2.ZERO]:
		tween.tween_property(camera,"offset",offset,.045)

func _show_banner(message: String) -> void:
	if is_instance_valid(_banner_tween): _banner_tween.kill()
	banner.text = message
	banner.position.y = 142
	banner.modulate.a = 0.0
	_banner_tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_banner_tween.set_parallel(true)
	_banner_tween.tween_property(banner,"modulate:a",1.0,.14)
	_banner_tween.tween_property(banner,"position:y",125.0,.2).set_trans(Tween.TRANS_BACK)
	_banner_tween.set_parallel(false)
	_banner_tween.tween_interval(.75)
	_banner_tween.tween_property(banner,"modulate:a",0.0,.22)

func layout() -> void:
	if not is_instance_valid(banner): return
	banner.position.x = (level.get_viewport_rect().size.x-banner.size.x)/2.0
