extends "res://tests/prototype_test.gd"

func first_slug() -> Node2D:
	for actor in level.actors.get_children():
		if actor.get_script()==preload("res://scripts/enemies/slug.gd"): return actor
	return null

func settle(point: Vector2) -> void:
	level.tico.reset_at(point)
	await frames(8)

func strike() -> void:
	key(KEY_E,true)
	await frames(12)
	key(KEY_E,false)
	await frames(28)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(SLOT)
	await open_level()
	var enemy := first_slug()
	enemy.set_physics_process(false)
	enemy.position = Vector2(530,760)
	enemy.origin = enemy.position
	await settle(Vector2(450,760))
	var player: CharacterBody2D = level.tico
	key(KEY_E,true)
	await frames(2)
	check(player.tail_phase=="prepare" and player.state==&"tail_prepare","E inicia preparação própria da caudada no chão")
	var attack_id: int = player.tail_attack_id
	check(not level.switch_character(),"Troca fica bloqueada durante a caudada")
	var phase_left: float = player.tail_phase_left
	level.set_paused(true)
	await frames(8)
	check(player.tail_phase_left==phase_left and not enemy.defeated,"Pausa congela a caudada e sua janela de acerto")
	level.set_paused(false)
	await frames(12)
	check(enemy.defeated and player.tail_phase in ["active","recover"],"Janela ativa derrota lesma à frente")
	await frames(40)
	check(player.tail_phase=="ready" and player.tail_attack_id==attack_id,"Segurar E produz somente um golpe")
	key(KEY_E,false)

	# Direção oposta usa o mesmo alcance curto.
	enemy.reset_enemy()
	enemy.set_physics_process(false)
	enemy.position = Vector2(370,760)
	enemy.origin = enemy.position
	await settle(Vector2(450,760))
	player.facing = -1
	await strike()
	check(enemy.defeated,"Caudada funciona para a esquerda")

	# Obstáculos sólidos bloqueiam o golpe.
	enemy.reset_enemy()
	enemy.set_physics_process(false)
	enemy.position = Vector2(550,760)
	enemy.origin = enemy.position
	var wall: StaticBody2D = level._solid("TailTestWall",Rect2(495,650,20,110),Color.WHITE)
	await settle(Vector2(450,760))
	player.facing = 1
	await strike()
	check(not enemy.defeated,"Caudada não atravessa parede")
	wall.queue_free()
	await frames(2)

	# A ação não começa no ar e dano cancela qualquer fase pendente.
	player.reset_at(Vector2(450,650))
	key(KEY_E,true)
	await frames(2)
	key(KEY_E,false)
	check(player.tail_phase=="ready","Caudada não começa no ar")
	await settle(Vector2(450,760))
	key(KEY_E,true)
	await frames(2)
	key(KEY_E,false)
	player.invulnerability_left = 0
	player.take_damage(player.position+Vector2(100,0))
	check(player.tail_phase=="ready","Dano cancela a caudada e limpa a janela de acerto")

	var hedgehog := preload("res://scripts/enemies/hedgehog.gd").new()
	check(not hedgehog.receive_tail(player),"Porco-espinho rejeita a caudada")
	hedgehog.free()
	var flying := preload("res://scripts/enemies/sky_enemy.gd").new()
	check(flying.receive_tail(player) and flying.defeated,"Inimigo voador aceita a caudada quando está ao alcance")
	flying.free()
	check(not level.stone.has_method("receive_tail") and not level.heavy.has_method("receive_tail"),"Caudada não interfere em pedra ou parede de força")

	player.invulnerability_left = 0
	await settle(Vector2(450,760))
	check(level.switch_character(),"Troca continua disponível após terminar o golpe")
	await frames(8)
	key(KEY_E,true)
	await frames(3)
	key(KEY_E,false)
	check(level.tico==level.pipo and not level.pipo.tail_enabled and level.pipo.ability=="prepare","Pipo mantém somente a investida no botão de ação")
	level.pipo.cancel_ability()
	check(level.touch.get_node("Action/Caption").text=="INVESTIR","Legenda de Pipo permanece INVESTIR")
	await close_level()
	DirAccess.remove_absolute(SLOT)
	print("RESULTADO E14: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
