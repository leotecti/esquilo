extends "res://tests/checkpoints_e03_test.gd"

func collect(actor: Node2D) -> void:
	level.tico.reset_at(actor.position+Vector2(0,25))
	await frames(4)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(0)
	var foods: Array = []
	var golden: Array = []
	var supply_blocks: Array = []
	var reward_x: Array[float] = []
	for actor in level.actors.get_children():
		if actor.has_method("reset_item"):
			if actor.collectible_kind=="food": foods.append(actor)
			elif actor.collectible_kind=="golden": golden.append(actor)
			if actor.collectible_kind in ["nut","food","golden"] and actor.position.x<level.main_right: reward_x.append(actor.position.x)
		elif actor.has_method("reset_block") and actor.kind==2 and str(actor.name).begins_with("SupplyBlock"):
			supply_blocks.append(actor)
			reward_x.append(actor.position.x)
	check(level.total_nuts==271,"E09 oferece 271 nozes incluindo blocos")
	check(level.total_foods==39 and foods.size()==39,"E09 oferece 39 alimentos variados")
	check(supply_blocks.size()==14,"E09 distribui 14 blocos de recompensa")
	check(golden.size()==2,"E09 oferece duas Nozes Douradas opcionais")
	reward_x.sort()
	var largest_gap := 0.0
	for i in range(1,reward_x.size()): largest_gap = maxf(largest_gap,reward_x[i]-reward_x[i-1])
	check(largest_gap<=650,"Percurso novo nÃ£o deixa mais de 650 unidades sem recompensa: %.0f" % largest_gap)
	var nuts_before: int = level.nuts
	for kind in 3:
		for food in foods:
			if food.food_kind==kind and not food.taken:
				await collect(food)
				break
	check(level.foods==3 and campaign.data.survival.food_total==3,"TrÃªs tipos de alimento abastecem o vilarejo")
	check(level.nuts==nuts_before and campaign.data.survival.nut_total==0,"Alimentos nÃ£o contam como nozes")
	await collect(golden[0])
	check(campaign.data.collectibles.golden_nuts["0"].size()==1,"Noz Dourada usa registro permanente")
	nuts_before = level.nuts
	var block: Node2D = supply_blocks[0]
	block.hit_from_below()
	await frames(3)
	check(block.used and level.nuts>=nuts_before+1,"Bloco concede uma noz")
	check(campaign.data.survival.nut_total>=1,"Bloco atualiza o contador global: %d" % campaign.data.survival.nut_total)
	var saved_food: int = campaign.data.survival.food_total
	campaign.save_progress()
	await close_world()
	await open_campaign()
	check(level.foods==3 and campaign.data.survival.food_total==saved_food,"Alimentos persistem ao reabrir")
	check(campaign.data.collectibles.golden_nuts["0"]==["trilha_alta_01"],"Noz Dourada nÃ£o duplica no save")
	check(campaign.store.valid(campaign.data),"Save E09 com alimentos e Noz Dourada Ã© vÃ¡lido")
	var permanent_food: int = campaign.data.survival.food_total
	var permanent_nuts: int = campaign.data.survival.nut_total
	campaign.save_progress()
	campaign.data.levels["0"].completed = true
	campaign.data.survival.replay = false
	campaign.data.stage = 0
	campaign.save_progress()
	check(campaign.data.levels["0"].completed,"Fixture registra fase concluÃ­da no save")
	await close_world()
	await open_campaign()
	check(level.completed,"Fixture reabre no mapa com fase concluÃ­da")
	campaign.show_map()
	await frames(12)
	campaign.world_map.focus_stage(0)
	campaign.world_map.primary.pressed.emit()
	await frames(35)
	level = campaign.level
	check(campaign.data.survival.replay and not level.completed,"BotÃ£o Jogar novamente inicia fase limpa")
	var replay_food: Node2D
	var replay_block: Node2D
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.collectible_kind=="food": replay_food = actor
		elif actor.has_method("reset_block") and str(actor.name).begins_with("SupplyBlock"): replay_block = actor
	check(is_instance_valid(replay_food) and not replay_food.taken and is_instance_valid(replay_block) and not replay_block.used,"Replay repÃµe alimentos e blocos interativos")
	await collect(replay_food)
	replay_block.hit_from_below()
	await frames(3)
	campaign.save_progress()
	check(campaign.data.survival.food_total==permanent_food+1,"Alimento coletado no replay volta a abastecer o vilarejo")
	check(campaign.data.survival.nut_total>permanent_nuts,"Bloco coletado no replay volta a contar para vidas")
	var replay_nuts_visible := 0
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.collectible_kind=="nut" and actor.visible: replay_nuts_visible += 1
	check(replay_nuts_visible>0,"Replay repÃµe nozes da fase para nova coleta")
	check(campaign.data.levels["0"].completed,"Replay preserva conclusÃ£o permanente da fase")
	campaign.save_progress()
	await close_world()
	await open_campaign()
	check(campaign.data.survival.nut_total>permanent_nuts,"Nozes do replay ficam contabilizadas apÃ³s reabrir")
	var invalid: Dictionary = campaign.data.duplicate(true)
	invalid.survival.food_total = -1
	check(not campaign.store.valid(invalid),"Save rejeita total de alimentos invÃ¡lido")
	var tree_gap := Rect2(20940,680,220,80)
	var gap_filled := false
	for rect in level.terrain:
		if rect.position.x<=tree_gap.position.x and rect.end.x>=tree_gap.end.x and rect.position.y<=tree_gap.position.y: gap_filled = true
	check(gap_filled,"DepressÃ£o abaixo da Ã¡rvore tem plataforma contÃ­nua de saÃ­da")
	campaign.data.survival.replay = false
	campaign.data.levels["0"].completed = false
	campaign.data.levels["0"].items = []
	campaign.data.levels["0"].blocks = []
	campaign.save_progress()
	await close_world()
	await open_campaign()
	for direction in [-1,1]:
		level.tico.reset_at(Vector2(21160,640))
		Input.action_press("move_left" if direction<0 else "move_right")
		await frames(30)
		Input.action_release("move_left" if direction<0 else "move_right")
		check(level.tico.position.x<21050 if direction<0 else level.tico.position.x>21150,"Personagem sai da plataforma da Ã¡rvore para %s" % ("esquerda" if direction<0 else "direita"))
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO: %d verificaÃ§Ãµes, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
