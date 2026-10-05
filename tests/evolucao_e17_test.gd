extends "res://tests/checkpoints_e03_test.gd"

const SLUG = preload("res://scripts/enemies/slug.gd")
const BEETLE = preload("res://scripts/enemies/beetle.gd")
const SPIDER = preload("res://scripts/enemies/spider.gd")
const BAT = preload("res://scripts/enemies/sky_enemy.gd")
const HEDGEHOG = preload("res://scripts/enemies/hedgehog.gd")
const CROW = preload("res://scripts/enemies/crow.gd")

func enemy_with(script: Script) -> Node2D:
	for actor in level.actors.get_children():
		if actor.get_script()==script: return actor
	return null

func check_art(enemy: Node2D, label: String) -> void:
	check(is_instance_valid(enemy) and enemy.has_node("EnemyArt"),label+" possui ilustração própria")
	if is_instance_valid(enemy): check(enemy.self_modulate.a==0.0,label+" não mistura arte nova com desenho provisório")

func run() -> void:
	for name in ["slug","beetle","spider","bat","hedgehog","crow"]:
		var texture: Texture2D = load("res://assets/enemies/%s.png" % name)
		check(texture.get_size()==Vector2(512,384),"Arte de %s usa tela padronizada e transparente" % name)

	await start_phase(0)
	check_art(enemy_with(SLUG),"Lesma")
	check(not is_instance_valid(enemy_with(BEETLE)) and not is_instance_valid(enemy_with(SPIDER)),"Primeiros Passos ensina somente a lesma")
	await close_world()

	await start_phase(1)
	var beetle := enemy_with(BEETLE)
	var hedgehog := enemy_with(HEDGEHOG)
	check_art(beetle,"Besouro")
	check_art(hedgehog,"Porco-espinho")
	level.tico.reset_at(beetle.position+Vector2(150,0))
	await frames(3)
	check(beetle.alert,"Besouro acelera quando percebe o personagem")
	check(beetle.receive_tail(level.tico) and beetle.defeated,"Besouro aceita pisão ou caudada")
	check(not hedgehog.receive_tail(level.tico),"Espinhos do porco-espinho rejeitam a caudada")
	await close_world()

	await start_phase(2)
	var spider := enemy_with(SPIDER)
	check_art(spider,"Aranha")
	var spider_y: float = spider.position.y
	await frames(12)
	check(not is_equal_approx(spider.position.y,spider_y),"Aranha apresenta ameaça vertical")
	check(spider.receive_tail(level.tico) and spider.defeated,"Aranha pode ser derrotada quando alcançada")
	await close_world()

	await start_phase(10)
	var bat := enemy_with(BAT)
	var crow := enemy_with(CROW)
	check_art(bat,"Morcego")
	check_art(crow,"Corvo patrulheiro")
	level.tico.reset_at(crow.position+Vector2(170,0))
	await frames(3)
	check(crow.chasing,"Corvo persegue por uma distância curta")
	check(bat.receive_tail(level.tico) and bat.defeated,"Morcego continua vulnerável a pisão e caudada")
	check(crow.receive_tail(level.tico) and crow.defeated,"Corvo pode ser derrotado quando alcançado")
	await close_world()

	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO E17: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
