extends "res://tests/checkpoints_e03_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await start_phase(1)
	var required := ["extra_life","defeat","game_over","unlock","boss_warning","boss_victory"]
	for effect in required:
		check(level.sounds.POLISH_EFFECTS.has(effect),"Efeito %s está carregado" % effect)
	level.feedback.react("checkpoint","Ponto seguro")
	await frames(2)
	check(level.feedback.events.get("checkpoint",0)==1 and level.feedback.flash.modulate.a>0,"Feedback combina clarão e mensagem")
	var lives_before: int = campaign.data.survival.lives
	check(campaign.claim_life(1,"galeria_12_life"),"Vida especial pode ser concedida no teste")
	check(campaign.data.survival.lives==lives_before+1 and level.sounds.played.get("extra_life",0)==1,"Vida extra possui som e resposta próprios")
	campaign.data.survival.lives = 1
	campaign.lose_life()
	check(campaign.awaiting_return() and level.sounds.played.get("game_over",0)==1,"Game Over possui som próprio e mantém o retorno previsto")
	campaign.data.survival.pending_return = false
	level.optional_area.travel(true)
	await create_timer(.55,true).timeout
	check(level.sounds.music.pitch_scale<.95,"Passagem noturna altera suavemente a ambientação musical")
	check(level.feedback.events.has("life") and level.feedback.events.has("defeat"),"Eventos importantes deixam resposta visual verificável")
	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO E21: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
