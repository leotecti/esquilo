extends CharacterBody2D
## Rocha pesada de 2-1. Pipo a empurra para a esquerda; a queda tensiona a
## corda e baixa a alavanca que abre o acesso às provisões.
signal activated(device: Node2D)

const BOULDER = preload("res://assets/objects/pushable_boulder.png")
@export var push_speed := 78.0
@export var fall_distance := 205.0
var level: Node2D
var lever_position := Vector2.ZERO
var origin := Vector2.ZERO
var active := false
var falling := false
var fall_time := 0.0
var _clock := 0.0
const FALL_DURATION := 0.72

func _ready() -> void:
	origin = position
	z_index = 2

func _physics_process(delta: float) -> void:
	_clock += delta
	if falling:
		fall_time += delta
		var progress := clampf(fall_time/FALL_DURATION,0.0,1.0)
		var eased := progress*progress*(3.0-2.0*progress)
		position = origin+Vector2(-fall_distance-34.0*eased,108.0*eased)
		rotation = -0.42*eased
		if progress>=1.0:
			falling = false
			active = true
		queue_redraw()
		return
	velocity.y = minf(velocity.y+1200.0*delta,900.0)
	move_and_slide()
	queue_redraw()

func push_by(character: Node2D, direction: float, delta: float) -> bool:
	if active or falling or direction>=-0.1 or not character.is_in_group("pipo") or not character.controls_enabled:
		return false
	var target_x := maxf(origin.x-fall_distance,position.x+direction*push_speed*delta)
	var before := position.x
	velocity = Vector2((target_x-position.x)/delta,0)
	move_and_slide()
	# O centro da rocha para na borda antes de alcançar o ponto geométrico do
	# rio. A margem considera o raio da colisão e inicia a queda sem frame preso.
	# Aciona antes que o corpo fique prensado entre Pipo e a borda. A animação
	# completa o deslocamento restante até o rio.
	if position.x<=origin.x-fall_distance+58.0:
		_begin_fall()
	return absf(position.x-before)>0.01

func _begin_fall() -> void:
	if falling or active: return
	falling = true
	fall_time = 0.0
	origin = Vector2(origin.x,position.y)
	$Collision.set_deferred("disabled",true)
	# A corda começa a baixar a alavanca no mesmo instante da queda. O sinal
	# antecipado impede que troca de personagem ou afastamento interrompa a
	# abertura da barreira antes do fim da animação.
	active = true
	activated.emit(self)

func activate(announce := true) -> void:
	if active: return
	active = true
	if falling:
		if announce: activated.emit(self)
		queue_redraw()
		return
	falling = false
	position = Vector2(origin.x-fall_distance-34.0,origin.y+108.0)
	rotation = -0.42
	$Collision.set_deferred("disabled",true)
	if announce: activated.emit(self)
	queue_redraw()

func is_falling() -> bool:
	return falling

func _draw() -> void:
	var lever_local := to_local(lever_position)
	var rope_start := Vector2(32,-47)
	var sag := 20.0*(1.0-clampf(fall_time/FALL_DURATION,0.0,1.0)) if falling else (4.0 if active else 20.0)
	var rope := PackedVector2Array()
	for i in 13:
		var t := float(i)/12.0
		var point := rope_start.lerp(lever_local+Vector2(-8,-48),t)
		point.y += sin(t*PI)*sag
		rope.append(point)
	draw_polyline(rope,Color("735238"),5.0,true)
	draw_polyline(rope,Color("c49a61"),2.0,true)
	draw_rect(Rect2(lever_local+Vector2(-9,-45),Vector2(18,45)),Color("765337"))
	draw_circle(lever_local+Vector2(0,-45),11,Color("d2a85f"))
	var arm_end := lever_local+Vector2(-30 if active or falling else 31,-74 if active or falling else -63)
	draw_line(lever_local+Vector2(0,-45),arm_end,Color("4c4035"),9.0,true)
	draw_circle(arm_end,10,Color("b65d3e"))
	# O asset recebe volume adicional, brilho e musgo para integrar a rocha ao rio.
	# A base visível entra alguns pixels no terreno para eliminar a impressão
	# de que a rocha flutua sobre a grama.
	draw_texture_rect(BOULDER,Rect2(-58,-80,116,86),false)
	draw_arc(Vector2(-8,-48),35,3.45,5.35,18,Color("d9c29a66"),3.0,true)
	for at in [Vector2(-35,-73),Vector2(-16,-81),Vector2(7,-78)]: draw_circle(at,7,Color("718d4c"))
