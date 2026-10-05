extends "res://tests/foundation_test.gd"

const SLOT := "user://e19_village_test_only.json"
var campaign: Node
var checks := 0

func check(condition: bool, message: String) -> void:
	checks += 1
	super.check(condition,message)

func open_campaign() -> void:
	campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.store.path = SLOT
	root.add_child(campaign)
	await frames(35)
	level = campaign.level

func close_campaign() -> void:
	campaign.queue_free()
	await frames(5)

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	DirAccess.remove_absolute(SLOT)
	await open_campaign()
	var info: Dictionary = campaign.village_progress()
	check(info.state==0 and info.food==0,"Vilarejo inicia em escassez com cestos vazios")
	campaign.data.survival.food_total = 20
	check(campaign.village_progress().state==1,"Vinte provisões iniciam a recuperação visual")
	campaign.data.survival.food_total = 75
	check(campaign.village_progress().state==2,"Setenta e cinco provisões preparam o vilarejo para o inverno")
	campaign.data.finished = true
	check(campaign.village_progress().state==3,"Vitória completa ativa a celebração da comunidade")
	campaign.data.finished = false
	campaign.data.survival.food_total = 24
	campaign._sync_village_flags()
	check(campaign.data.story.village.state_1 and not campaign.data.story.village.state_0,"Estado derivado também fica registrado no Save V2")
	var summary: Dictionary = campaign.progress_summary()
	check(summary.village.state==1 and summary.village.food==24,"Consulta geral expõe o progresso do vilarejo")
	campaign.show_map()
	await frames(8)
	check(is_instance_valid(campaign.world_map.village_button),"Mapa oferece acesso permanente ao vilarejo")
	campaign.world_map.village_button.pressed.emit()
	await frames(5)
	var details: Dictionary = campaign.world_map.details().village
	check(details.village_open and details.village_state==1,"Visita apresenta o estado intermediário salvo")
	check(details.village_title=="Recuperação" and details.village_food==24,"Tela comunica estado e quantidade de provisões")
	campaign.world_map.village_view.close_button.pressed.emit()
	await frames(4)
	check(not is_instance_valid(campaign.world_map.village_view),"Jogador retorna ao mapa pela própria tela do vilarejo")
	campaign.save_progress()
	await close_campaign()
	await open_campaign()
	check(campaign.village_progress().state==1 and campaign.data.story.village.state_1,"Progresso visual persiste após reabrir o jogo")
	await close_campaign()
	DirAccess.remove_absolute(SLOT)
	print("RESULTADO E19: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
