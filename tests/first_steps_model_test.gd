extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(0)
	check(level.total_nuts==271,"Modelo E09 tem 245 nozes principais e 26 na copa")
	check(level.optional_area.ENTRY.x/level.main_right==.5,"Copa está no meio do percurso")
	var flags := 0
	for actor in level.actors.get_children():
		if actor.get_script()==level.checkpoint.get_script() and not actor.finish: flags += 1
	check(flags==1 and level.checkpoint.position.x>21000,"Uma única bandeira após a árvore")
	for enemy in level.actors.get_children():
		if enemy.has_method("reset_enemy"): enemy.defeated = true
	level.tico.invulnerability_left = 10000
	var pickups: Array = []
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.collectible_kind=="nut": pickups.append(actor)
	var initial: int = campaign.data.survival.lives
	for i in 200:
		level.tico.reset_at(pickups[i].position+Vector2(0,25))
		await frames(3)
		if i in [98,99,198,199]:
			check(campaign.data.survival.nut_total==i+1,"Contador registra coleta %d" % (i+1))
			check(campaign.data.survival.lives==initial+(i+1)/100,"Vida é concedida apenas a cada 100 nozes: %d" % (i+1))
	var lives: int = campaign.data.survival.lives
	campaign.save_progress()
	campaign.save_progress()
	check(campaign.data.survival.lives==lives,"Salvar novamente não repete recompensa")
	await close_world()
	await open_campaign()
	check(level.nuts==200 and campaign.data.survival.nut_total==200,"Mais de 64 itens e contador sobrevivem à reabertura")
	check(campaign.data.survival.lives==lives,"Reabrir não duplica vidas")
	level._on_checkpoint(level.checkpoint)
	var checkpoint_position: Vector2 = level.checkpoint_position
	level._on_checkpoint(level.checkpoint)
	check(level.checkpoint_position==checkpoint_position,"Bandeira antiga não recua retorno")
	await close_world()
	await open_campaign()
	check(level.checkpoint_active and level.checkpoint_position==checkpoint_position,"Bandeira única persiste")
	level.optional_area.travel(true)
	await create_timer(.45,true).timeout
	var heart: Node2D
	var hearts := 0
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.healing and actor.position.x>60000:
			if actor.get_meta("save_id","")=="7970:405": heart = actor
			hearts += 1
	check(hearts==3,"Copa oferece três corações")
	level.tico.health = 2
	level.tico.reset_at(heart.position+Vector2(0,25))
	await frames(4)
	check(heart.taken and level.tico.health==3,"Coração recupera saúde")
	check(campaign.data.survival.nut_total==200,"Coração não conta como noz")
	var full_heart: Node2D
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.healing and not actor.taken: full_heart = actor
	lives = campaign.data.survival.lives
	level.tico.reset_at(full_heart.position+Vector2(0,25))
	await frames(4)
	check(full_heart.taken and campaign.data.survival.lives==lives+1,"Coração com saúde cheia concede uma vida")
	campaign.save_progress()
	await close_world()
	await open_campaign()
	check(campaign.data.survival.lives==lives+1,"Vida do coração persiste sem duplicação")
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.healing and not actor.taken: full_heart = actor
	level._activate(level.pipo,full_heart.position+Vector2(0,25))
	level.tico.health = 3
	campaign.data.survival.lives = 99
	await frames(4)
	check(not full_heart.taken and campaign.data.survival.lives==99,"No limite de vidas, coração permanece disponível")
	campaign.data.survival.lives = 98
	await frames(4)
	check(full_heart.taken and campaign.data.survival.lives==99,"Pipo também converte coração em vida, sem exceder 99")
	var invalid: Dictionary = campaign.data.duplicate(true)
	invalid.survival.nut_total = -1
	check(not campaign.store.valid(invalid),"Save rejeita contador inválido")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
