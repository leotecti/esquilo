extends Node
## Uma dica por vez, sem pausar nem capturar os controles do jogador.
const KEYS = ["tutorial_enemy_seen","tutorial_heart_seen","tutorial_life_seen","tutorial_glide_seen","tutorial_secret_seen"]
var level: Node2D
var panel: Panel
var caption: Label
var adventure_button: Button
var signs: Array[Label] = []
var targets: Array[Node2D] = []
var active_id := ""
var active_kind := ""
var active_target: CanvasItem
var remaining := 0.0
var cooldown := 0.0
var scan_left := 0.0
var _origin := Vector2.ZERO

func _ready() -> void:
	for actor in level.actors.get_children():
		if actor is Label and actor.has_meta("context_hint"):
			signs.append(actor)
			actor.hide()
		elif actor.has_method("reset_item") or actor.has_method("reset_enemy") or actor.has_meta("extra_life"):
			targets.append(actor)
	var column: VBoxContainer = level.pause_panel.get_child(0)
	adventure_button = column.get_child(column.get_child_count()-1).get_child(1)
	level.save_label.reparent(column)
	level.save_label.position = Vector2.ZERO
	level.save_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# Altura explícita evita realimentação entre a largura e o mínimo do texto quebrado.
	panel = Panel.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel",level._box(Color("fff3d9f2"),Color("acc88d")))
	level.get_node("Interface/HUD").add_child(panel)
	caption = Label.new()
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.max_lines_visible = 2
	caption.clip_text = true
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_color_override("font_color",Color("244b37"))
	caption.add_theme_font_size_override("font_size",24)
	panel.add_child(caption)
	panel.hide()
	layout()

func layout() -> void:
	if not is_instance_valid(panel): return
	var bar: HBoxContainer = level.get_node("Interface/HUD/TopBar")
	bar.get_node("Title").hide()
	bar.get_node("Restart").hide()
	var view: Vector2 = level.get_viewport_rect().size
	var inset: Vector4 = level.touch.safe_insets()
	# Reserva uma área à direita, independente do tamanho mínimo do HBox herdado.
	bar.anchor_left = 0
	bar.anchor_right = 0
	var controls_width: float = bar.get_combined_minimum_size().x
	bar.position = Vector2(view.x-32-inset.z-controls_width,20+inset.y)
	bar.size = Vector2(controls_width,88 if level.touch.touch_enabled else 44)
	level.status.hide()
	level.hearts.position = Vector2(32+level.touch.safe_insets().x,bar.offset_top+(bar.size.y-38)/2)
	level.hud_panel.size.y = bar.offset_bottom+10-level.hud_panel.position.y
	var tip_width := minf(720,view.x-64)
	var font := caption.get_theme_font("font")
	var text_height := font.get_multiline_string_size(caption.text,HORIZONTAL_ALIGNMENT_LEFT,tip_width-36,24,2).y
	panel.size = Vector2(tip_width,clampf(ceilf(text_height)+20,52,92))
	caption.position = Vector2(18,10)
	caption.size = panel.size-Vector2(36,20)
	panel.position = Vector2((view.x-panel.size.x)/2,bar.offset_bottom+20)
	var column: VBoxContainer = level.pause_panel.get_child(0)
	column.get_child(0).text = bar.get_node("Title").text.split("\n")[0]
	level.pause_panel.size.y = maxf(420,level.pause_panel.get_combined_minimum_size().y)
	level.pause_panel.position = (view-level.pause_panel.size)/2

func notify(message: String) -> void:
	if not is_instance_valid(panel) or level.completed or level.respawning: return
	_display("",message,"notice",null,3.5)

func _display(id: String, message: String, kind: String, target: CanvasItem = null, duration := 5.0) -> void:
	active_id = id
	active_kind = kind
	active_target = target
	remaining = duration
	_origin = level.tico.position
	caption.text = message
	panel.show()
	layout()
	if not id.is_empty(): level.campaign.mark_hint_seen(id)

func clear() -> void:
	active_id = ""
	active_kind = ""
	active_target = null
	remaining = 0
	cooldown = 1.0
	panel.hide()

func _process(delta: float) -> void:
	if level.get_tree().paused or level.campaign.awaiting_return():
		panel.hide()
		return
	if level.completed or level.respawning:
		clear()
		return
	if remaining>0:
		remaining -= delta
		if remaining<=0 or _interacted(): clear()
		else: panel.show()
	cooldown = maxf(0,cooldown-delta)
	scan_left -= delta
	if scan_left>0 or cooldown>0: return
	scan_left = 0.15
	if remaining>0 and active_kind not in ["sign","walk"]: return
	var candidate := _candidate()
	if not candidate.is_empty():
		_display(candidate[0],candidate[1],candidate[2],candidate[3])
		return
	if remaining>0: return
	if not _seen("walk") and level.tico.position.x<300:
		_display("walk","Use as setas para andar. " + ("Toque em PULO para saltar." if level.touch.touch_enabled else "Aperte Espaço para saltar."),"walk")
		return
	for sign in signs:
		var id := "sign_%d_%d_%d" % [int(level.campaign.data.stage),int(sign.position.x),int(sign.position.y)]
		if not _seen(id) and level.tico.position.x<sign.position.x+80 and absf(level.tico.position.x-sign.position.x)<180 and absf(level.tico.position.y-sign.position.y)<300:
			_display(id,str(sign.get_meta("context_hint")).replace("\n",". "),"sign",sign,4.0)
			return

func _seen(id: String) -> bool:
	if id in KEYS: return level.campaign.data.tutorials[id]
	return id in level.campaign.data.context_hints_seen

func _candidate() -> Array:
	var player: CharacterBody2D = level.tico
	for target in targets:
		if not is_instance_valid(target) or not target.visible: continue
		var offset: Vector2 = target.position-player.position
		if offset.x< -80 or offset.x>250 or absf(offset.y)>140: continue
		if target.has_meta("extra_life") and not target.taken and not _seen(KEYS[2]):
			return [KEYS[2],"Uma vida extra! Pule para pegar o medalhão.","life",target]
		if target.has_method("reset_item") and target.healing and not target.taken and player.health<player.max_health and not _seen(KEYS[1]):
			return [KEYS[1],"Pegue o coração para recuperar sua saúde.","heart",target]
		if target.has_method("reset_enemy") and target!=level.guardian and not target.get("defeated") and not _seen(KEYS[0]):
			var spiky: bool = target.get_script()==preload("res://scripts/enemies/hedgehog.gd")
			return [KEYS[0],"Tem espinhos! Passe por cima sem encostar." if spiky else "Dê um salto sobre ele!","enemy",target]
	if not _seen(KEYS[3]) and player==level.squirrel and player.state==&"fall" and not player.is_on_floor():
		var ray := PhysicsRayQueryParameters2D.create(player.position+Vector2(0,2),player.position+Vector2(0,140),1)
		if level.get_world_2d().direct_space_state.intersect_ray(ray).is_empty():
			return [KEYS[3],"Segure %s no ar para planar." % ("PULO" if level.touch.touch_enabled else "Espaço"),"glide",null]
	if not _seen(KEYS[4]) and level.rescued and is_instance_valid(level.secret) and not level.secret.revealed and player.position.distance_to(level.secret.position)<300:
		return [KEYS[4],"Siga o faro de Pipo até o segredo!" if player==level.pipo else "Chame Pipo! Ele fareja segredos por perto.","secret",level.secret]
	return []

func _interacted() -> bool:
	if active_kind=="walk": return level.tico.position.distance_to(_origin)>60
	if active_kind=="glide": return level.tico.state==&"glide" or level.tico.is_on_floor() or level.tico!=level.squirrel
	if not is_instance_valid(active_target): return active_kind not in ["notice","walk","glide"]
	if active_kind in ["life","heart"] and active_target.taken: return true
	if active_kind=="enemy" and active_target.get("defeated"): return true
	if active_kind=="secret" and (active_target.revealed or level.tico==level.pipo and level.tico.position.distance_to(_origin)>30): return true
	return absf(level.tico.position.x-active_target.position.x)>350 or level.tico.position.x>active_target.position.x+100

func details() -> Dictionary:
	var rect := adventure_button.get_global_rect()
	return {"hint_id":active_id,"hint_text":caption.text if panel.visible else "","hint_visible":panel.visible,
		"hint_size":[panel.size.x,panel.size.y],
		"hud_controls_clear":level.portrait.get_global_rect().position.x>level.campaign.lives_label.get_global_rect().end.x,
		"tutorials":level.campaign.data.tutorials.duplicate(),"compact_hud_height":level.hud_panel.size.y,
		"restart_rect":[rect.position.x,rect.position.y,rect.size.x,rect.size.y]}
