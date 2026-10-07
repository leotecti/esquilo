extends "res://tests/expedition_test.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	await open_stage(2,"1")
	var armored_enemies: Array = level.actors.get_children().filter(func(actor): return actor.has_method("receive_charge") and actor.get("armored")!=null)
	check(armored_enemies.size()>=1,"Mundo 2 apresenta besouro com defesa quebrável")
	var enemy: Node2D = armored_enemies[0]
	check(enemy.armored and not enemy.armor_broken,"Besouro começa protegido pela carapaça")
	check(not enemy.receive_tail(level.squirrel) and enemy.armored and not enemy.defeated,"Caudada de Tico não atravessa a defesa")
	level.pipo.ability = "charge"
	level.pipo.charge_direction = 1
	check(enemy.receive_charge(level.pipo) and not enemy.armored and enemy.armor_broken,"Investida de Pipo quebra a defesa")
	check(enemy.visible and not enemy.defeated,"Quebrar a armadura abre a finalização sem derrotar imediatamente")
	check(enemy.receive_tail(level.squirrel) and enemy.defeated,"Depois da quebra, Tico pode finalizar com a caudada")
	enemy.reset_enemy()
	check(enemy.armored and not enemy.armor_broken and not enemy.defeated,"Respawn restaura o encontro completo")
	await close_level()
	await open_stage(2,"2")
	check(level.actors.get_children().any(func(actor): return actor.get("armored")!=null),"Outra fase do rio reutiliza o inimigo blindado")
	await close_level()
	print("RESULTADO INIMIGO BLINDADO: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
