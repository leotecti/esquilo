extends Node2D
## Protótipo de área secundária: identidade e pontos de retorno estáveis.
const ENTRY := Vector2(1340,340)
const START := Vector2(6100,755)
const FLAG := Vector2(6550,655)
const EXIT := Vector2(7350,360)
var level: Node2D
var active := false
var checkpoint := false
var transitioning := false
var flag: Area2D
var veil: ColorRect

func build() -> void:
	for rect in [Rect2(1250,540,180,24),Rect2(1430,440,180,24),Rect2(1220,340,240,28),
		Rect2(5900,760,1800,200),Rect2(6400,660,300,28),Rect2(6700,560,230,28),
		Rect2(6940,460,230,28),Rect2(7190,360,360,32)]: level._platform(rect)
	for rect in [Rect2(5850,-300,50,1500),Rect2(7700,-300,50,1500)]:
		level._solid("CopaBoundary",rect,Color.TRANSPARENT)
	for point in [Vector2(6500,615),Vector2(6810,515),Vector2(7060,415),Vector2(7290,315)]: level._nut(point)
	flag = level.CHECKPOINT.instantiate()
	flag.position = FLAG+Vector2(0,5)
	flag.set_meta("checkpoint_marker",true)
	level.actors.add_child(flag)
	flag.reached.connect(func(_marker):
		checkpoint = true
		level.tico.recover(level.tico.max_health)
		level._say("Bandeira da copa ativada! Explore no seu ritmo.")
		level._save_progress())
	for entry in [[ENTRY,"Ação • Explorar a copa"],[START+Vector2(0,5),"Ação • Voltar à trilha"],[EXIT,"Ação • Voltar à trilha"]]:
		var label := Label.new()
		label.text = entry[1]
		label.position = entry[0]+Vector2(-115,-125)
		label.add_theme_font_size_override("font_size",22)
		label.add_theme_color_override("font_color",Color("244b37"))
		add_child(label)
	var caption := Label.new()
	caption.text = "A copa dos segredos\nSuba pelos galhos e encontre as nozes!"
	caption.position = Vector2(6300,290)
	caption.add_theme_font_size_override("font_size",26)
	add_child(caption)
	var layer := CanvasLayer.new()
	layer.layer = 19
	add_child(layer)
	veil = ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color("244b37")
	veil.modulate.a = 0
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(veil)
	queue_redraw()

func _physics_process(_delta: float) -> void:
	if transitioning or level.completed or level.respawning: return
	if active and level.tico.position.y>980:
		level.tico.take_damage(level.tico.position+Vector2(0,30))
		if level.tico.health>0: restore_player()
	if Input.is_action_just_pressed("action") and level.tico.is_on_floor():
		var point: Vector2 = level.tico.position
		if not active and point.distance_to(ENTRY)<95: travel(true)
		elif active and (point.distance_to(START)<95 or point.distance_to(EXIT)<95): travel(false)

func travel(entering: bool) -> void:
	if transitioning or level.completed or level.respawning: return
	transitioning = true
	level.tico.controls_enabled = false
	level.touch.release_all()
	for action in ["move_left","move_right","jump","action","switch_character"]: Input.action_release(action)
	var tween := create_tween()
	tween.tween_property(veil,"modulate:a",1.0,.16)
	tween.tween_callback(func():
		active = entering
		apply_camera()
		level.tico.reset_at(START if entering else ENTRY+Vector2(0,-5))
		level.tico.controls_enabled = false
		level.camera.snap_to_target()
		level._save_progress()
		level._say("Explore a copa! A bandeira guarda seu retorno." if entering else "De volta à trilha principal!"))
	tween.tween_property(veil,"modulate:a",0.0,.16)
	tween.tween_callback(func():
		level.tico.controls_enabled = true
		transitioning = false)

func apply_camera() -> void:
	level.camera.limit_left = 5900 if active else 0
	level.camera.limit_right = 7700 if active else 3800

func restore_player() -> void:
	apply_camera()
	if active: level.tico.reset_at(FLAG if checkpoint else START)
	level.camera.snap_to_target()

func snapshot() -> Dictionary:
	return {"active":active,"checkpoint":checkpoint}

func restore(state: Dictionary) -> void:
	active = state.get("active",false) and not level.completed
	checkpoint = state.get("checkpoint",false)
	flag.activated = checkpoint
	flag.queue_redraw()
	restore_player()

func _draw() -> void:
	var atlas := preload("res://scripts/presentation/atlas_library.gd")
	# A mesma vegetação e os mesmos materiais usados no bosque.
	for trunk in [Rect2(1300,280,80,480),Rect2(6520,370,100,390),Rect2(7210,140,110,620)]:
		draw_rect(trunk,Color("735133"))
		for stripe in range(3): draw_line(trunk.position+Vector2(15+stripe*23,0),trunk.position+Vector2(15+stripe*23,trunk.size.y),Color("9a7449"),5)
		for offset in [-100,0,100]: draw_texture_rect(atlas.frame("props",7),Rect2(trunk.position+Vector2(offset-60,-120),Vector2(200,150)),false)
	for point in [ENTRY,START+Vector2(0,5),EXIT]:
		draw_arc(point+Vector2(0,-43),42,PI,TAU,32,Color("d0a65a"),10,true)
		draw_line(point+Vector2(-42,-43),point+Vector2(-42,0),Color("d0a65a"),10,true)
		draw_line(point+Vector2(42,-43),point+Vector2(42,0),Color("d0a65a"),10,true)
		draw_circle(point+Vector2(0,-40),25,Color("ffeab17f"))
