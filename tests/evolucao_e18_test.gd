extends "res://tests/expedition_routes_test.gd"

func hit_boss(boss: Node2D,world: int,expected_health: int) -> bool:
	boss.invulnerable = 0.0
	boss.phase = "tired"
	if world==1:
		boss.position = boss.home_position
		await place(Vector2(boss.position.x+78.0,boss.position.y-155.0),25)
		if expected_health==0: await frames(80)
		return boss.health==expected_health
	return boss.receive_hit() and boss.health==expected_health

func validate_boss(world: int) -> void:
	await open_stage(world,"guardian")
	var boss: Node2D = level.guardian
	var names := ["Periquito do Bosque","Guardião do Rio","Gavião da Montanha","Rei Castor"]
	check(boss.encounter_stage()==1,names[world-1]+" inicia no padrão simples")
	if world==1:
		check(not boss.accepts_charge(),"Investida de Pipo não causa dano ao Periquito")
		var start_position: Vector2 = boss.position
		level.tico.reset_at(start_position+Vector2(-120,0))
		await frames(30)
		check(boss.position.distance_to(start_position)>5.0,"Periquito patrulha no ar em direção ao personagem ativo")
		boss.phase = "warning"
		boss.remaining = 0.01
		level.tico.reset_at(boss.home_position+Vector2(180,0))
		await frames(3)
		check(boss.phase=="attack" and boss.attack_target.x>boss.home_position.x,"Periquito mira Tico ou Pipo antes de avançar")
		boss.position = boss.home_position+Vector2(115,-6)
		boss.phase = "attack"
		boss.remaining = 0.01
		await frames(2)
		var landing: Vector2 = boss.position
		await frames(30)
		check(boss.phase=="tired" and boss.position.distance_to(landing)<0.1,"Periquito permanece no ponto do pouso enquanto recupera o fôlego")
		boss.phase = "waiting"
		boss.remaining = boss.phase_duration("waiting")
	elif world==2:
		check(boss.accepts_charge(),"Guardião do Rio preserva a investida de Pipo")
	var reach_1: float = boss.attack_reach()
	var warning_1: float = boss.phase_duration("warning")
	check(not boss.receive_hit(),names[world-1]+" permanece protegido fora da abertura")
	check(await hit_boss(boss,world,2),names[world-1]+" aceita o primeiro acerto na abertura")
	check(boss.encounter_stage()==2 and boss.attack_reach()>reach_1,names[world-1]+" amplia o segundo padrão")
	var reach_2: float = boss.attack_reach()
	check(await hit_boss(boss,world,1),names[world-1]+" alcança a combinação final")
	check(boss.encounter_stage()==3 and boss.attack_reach()>reach_2,names[world-1]+" combina alcance e ritmo no terceiro padrão")
	check(boss.phase_duration("warning")<warning_1 and boss.phase_duration("tired")>=3.5,names[world-1]+" acelera o aviso sem retirar a janela de reação")
	var final_hit := await hit_boss(boss,world,0)
	check(final_hit and boss.phase==("vanished" if world==1 else "calm"),names[world-1]+" encerra o confronto sem eliminar o personagem")
	if world==1:
		check(not boss.visible,"Periquito cai e desaparece depois do terceiro pulo")
		check(is_finite(level.tico.auto_run_target),"Personagem inicia corrida automática em direção ao portal")
		await frames(180)
		check(level.completed,"Corrida até o portal conclui a fase do Periquito")
	await close_level()

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	var parakeet_states: Texture2D = load("res://assets/bosses/parakeet_guardian_states_v3.png")
	check(parakeet_states.get_size()==Vector2(2048,512),"Periquito possui quatro estados visuais padronizados")
	for world in [1,2,3,4]: await validate_boss(world)
	print("RESULTADO E18: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
