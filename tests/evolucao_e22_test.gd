extends "res://tests/checkpoints_e03_test.gd"
const BALANCE = preload("res://scripts/systems/game_balance.gd")

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	check(BALANCE.PLAYER_MAX_HEALTH==3 and BALANCE.INITIAL_LIVES==3,"Perfil mantém três corações e três vidas iniciais")
	check(BALANCE.NUTS_PER_LIFE==100 and BALANCE.MAX_LIVES==99,"Economia de vidas possui limites centralizados")
	check(BALANCE.TICO_MOVE_SPEED==300.0 and BALANCE.PIPO_JUMP_VELOCITY>BALANCE.TICO_JUMP_VELOCITY,"Tico preserva agilidade e Pipo mantém salto menor")
	check(BALANCE.DAMAGE_INVULNERABILITY>=1.2,"Dano concede tempo de recuperação adequado ao público infantil")
	check(BALANCE.BOSS_HEALTH==3 and BALANCE.BOSS_TIRED.min()>=3.5,"Chefes exigem três acertos e mantêm abertura legível")
	check(BALANCE.BOSS_WARNING[2]>=1.0 and BALANCE.BOSS_REACH[0]<BALANCE.BOSS_REACH[2],"Chefe progride por alcance sem retirar o aviso mínimo")
	await start_phase(0)
	check(campaign.initial_lives==BALANCE.INITIAL_LIVES and level.tico.max_health==BALANCE.PLAYER_MAX_HEALTH,"Campanha e personagem consomem o perfil central")
	check(level.total_nuts>=250 and level.total_foods>=BALANCE.FIRST_LEVEL_MIN_FOODS,"Primeiros Passos sustenta coleta durante cinco a oito minutos")
	var hearts := 0
	for actor in level.actors.get_children():
		if actor.has_method("reset_item") and actor.collectible_kind=="heart": hearts += 1
	check(hearts>=BALANCE.FIRST_LEVEL_MIN_HEARTS,"Fase modelo oferece recuperação sem remover o risco")
	var checkpoint_fraction: float = level.checkpoint.position.x/level.main_right
	check(checkpoint_fraction>=BALANCE.FIRST_LEVEL_CHECKPOINT_FRACTION.x and checkpoint_fraction<=BALANCE.FIRST_LEVEL_CHECKPOINT_FRACTION.y,"Checkpoint fica depois da metade e antes do trecho final")
	var uninterrupted_seconds: float = level.main_right/BALANCE.TICO_MOVE_SPEED
	check(uninterrupted_seconds>120 and uninterrupted_seconds<180,"Extensão base deixa espaço para exploração dentro da meta de duração")
	check(BALANCE.FIRST_LEVEL_TARGET_SECONDS==Vector2i(300,480),"Meta aprovada de cinco a oito minutos está registrada")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO E22: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
