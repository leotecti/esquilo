extends "res://tests/expedition_save_test.gd"
const E02_SLOT := "user://e02_test_only.json"
const E02_LEGACY := "user://e02_legacy_test_only.json"

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.store.path = E02_SLOT
	campaign.legacy_path = E02_LEGACY
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func defeat() -> void:
	level.tico.health = 1
	level.tico.invulnerability_left = 0
	level.tico.take_damage(level.tico.position+Vector2(100,0))

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(E02_LEGACY)
	write_raw(E02_SLOT,JSON.stringify(fixture(0)))
	await open_campaign()
	check(campaign.data.survival.lives==3,"Campanha antiga recebe três vidas")
	check(not level.switch_character(),"Pipo continua bloqueado antes do resgate")
	level.tico.reset_at(Vector2(450,675))
	await frames(8)
	check(campaign.data.survival.lives==4,"Colisão coleta medalhão de vida extra")
	check(not campaign.claim_life(0),"Vida extra não duplica na mesma fase")
	defeat()
	check(campaign.data.survival.lives==3,"Derrota desconta uma vida imediatamente")
	level._on_defeat()
	check(campaign.data.survival.lives==3,"Sinal repetido não desconta outra vida")
	await frames(80)
	check(level.tico.health==3 and not level.respawning,"Vidas restantes usam retorno existente")
	await close_world()
	await open_campaign()
	check(campaign.data.survival.lives==3 and not campaign.claim_life(0),"Vidas e recompensa persistem ao reabrir")
	await close_world()
	for index in [0,4,8,12]:
		write_raw(E02_SLOT,JSON.stringify(fixture(index)))
		await open_campaign()
		campaign.data.survival.lives = 1
		defeat()
		var target := maxi(0,(index/4-1)*4)
		check(campaign.awaiting_return() and campaign.data.survival.return_stage==target,"Game Over escolhe mundo anterior: %d" % index)
		check(campaign.store.read_save().survival.pending_return,"Game Over salvo antes da animação: %d" % index)
		await close_world()
		await open_campaign()
		check(paused and is_instance_valid(campaign.return_button),"Reabertura recupera tela de retorno: %d" % index)
		level.set_paused(false)
		check(paused,"Pausa não permite escapar do Game Over")
		campaign.resume_at(target)
		await frames(40)
		level = campaign.level
		check(campaign.data.stage==target and not level.completed and not paused,"Retorno abre fase jogável: %d" % target)
		check(campaign.data.unlocked==index and campaign.data.survival.lives==3,"Preserva desbloqueios e renova vidas")
		check(campaign.store.valid(campaign.data),"Save de retorno atende ao esquema")
		if index>0:
			check(level.switch_character() and level.tico==level.pipo,"Pipo resgatado funciona no mundo anterior")
			defeat()
			check(campaign.data.survival.lives==2,"Pipo usa as mesmas vidas")
			await frames(80)
		await close_world()
		await open_campaign()
		check(campaign.data.stage==target and not level.completed,"Reabrir mantém tentativa e destino")
		await close_world()
	var invalid := fixture(4)
	invalid.survival = {"lives":-1,"pending_return":false,"return_stage":0,"replay":false,"pipo_unlocked":true,"claimed":[]}
	check(not CAMPAIGN_SAVE.new().valid(invalid),"Rejeita contador inválido")
	DirAccess.remove_absolute(E02_SLOT)
	DirAccess.remove_absolute(E02_LEGACY)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
