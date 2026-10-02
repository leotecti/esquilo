extends "res://tests/map_e06_test.gd"

func arrow(code: Key) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.pressed = true
	root.push_input(event)
	await create_timer(1.05,true).timeout

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	write_raw(MAP_SLOT,JSON.stringify(fixture(4)))
	await open_campaign()
	campaign.world_map.move_to_stage(3)
	check(campaign.world_map._actor_point.distance_to(campaign.world_map.point(3))>100,"Caminhada começa antes do destino, sem salto inicial")
	await create_timer(.2,true).timeout
	check(is_equal_approx(campaign.world_map.squirrel.size.y,92),"Quadros preservam altura do personagem")
	check(is_equal_approx(campaign.world_map.squirrel.position.y+campaign.world_map.squirrel.size.y,campaign.world_map._actor_point.y-42),"Pés mantêm apoio durante caminhada")
	campaign.world_map.focus_stage(4)
	check(not campaign.world_map._walking,"Mudança de página interrompe animação antiga")
	await arrow(KEY_LEFT)
	check(campaign.world_map.selected==3 and campaign.world_map.world==0,"Esquerda atravessa para mundo anterior")
	check(campaign.world_map.squirrel.visible and campaign.world_map.companion.visible,"Tico e Pipo acompanham seleção")
	check(campaign.world_map._actor_point.is_equal_approx(campaign.world_map.point(3)),"Personagens chegam ao destino")
	await arrow(KEY_RIGHT)
	check(campaign.world_map.selected==4 and campaign.world_map.world==1,"Direita atravessa para mundo desbloqueado")
	await arrow(KEY_UP)
	check(campaign.world_map.selected==4,"Fase bloqueada impede avanço")
	await arrow(KEY_DOWN)
	check(campaign.world_map.selected==3,"Baixo retorna pela trilha")
	check(campaign.data.stage==4 and campaign.store.read_save().stage==4,"Navegar não altera fase salva")
	check(campaign.map_is_open(),"Entrada exige confirmação")
	campaign.enter_from_map(3)
	await frames(8)
	check(campaign.data.stage==3 and not campaign.map_is_open(),"Confirmação abre destino selecionado")
	await close_world()
	DirAccess.remove_absolute(MAP_SLOT)
	print("RESULTADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
