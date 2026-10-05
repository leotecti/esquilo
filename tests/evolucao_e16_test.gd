extends "res://tests/checkpoints_e03_test.gd"

const LAYOUT = preload("res://scripts/systems/first_steps_layout.gd")
const SLUG = preload("res://scripts/enemies/slug.gd")

func run() -> void:
	await start_phase(0)
	var segments: Array = LAYOUT.DIFFICULTY_CURVE
	check(segments.size()==5,"Curva possui aprender, praticar, combinar, desafiar e chegada")
	check(segments[0].start==0.0 and segments[-1].end==42000.0,"Curva cobre toda a fase")
	for index in range(segments.size()-1):
		check(segments[index].end==segments[index+1].start,"Trechos %d e %d não deixam lacuna" % [index,index+1])

	var counts := {"learn":0,"practice":0,"combine":0,"challenge":0,"recover":0}
	var speeds := {"learn":[],"practice":[],"combine":[],"challenge":[],"recover":[]}
	for actor in level.actors.get_children():
		if actor.get_script()!=SLUG or actor.position.x>=level.optional_area.SIDE_OFFSET.x: continue
		var phase: String = actor.get_meta("difficulty_phase","")
		counts[phase] += 1
		speeds[phase].append(actor.speed)
		var expected: Dictionary = LAYOUT.difficulty_phase(actor.position.x)
		check(phase==expected.id and actor.speed==expected.slug_speed,"Lesma em x=%d segue a faixa %s" % [actor.position.x,expected.label])

	check(counts=={"learn":2,"practice":2,"combine":2,"challenge":2,"recover":0},"Encontros avançam em pares e a chegada fica tranquila")
	check(speeds.learn.all(func(value): return value==45.0) and speeds.practice.all(func(value): return value==45.0),"Aprendizado e prática preservam velocidade base")
	check(speeds.combine.all(func(value): return value==50.0),"Combinação aumenta a pressão de forma moderada")
	check(speeds.challenge.all(func(value): return value==55.0),"Desafio final aumenta a reação sem duplicar inimigos")
	check(level.checkpoint.position.x>=segments[2].start and level.checkpoint.position.x<segments[2].end,"Bandeira permanece após a copa na faixa de combinação")
	check(level.exit_marker.position.x>=segments[-1].start,"Chegada oferece recuperação após o último desafio")

	await close_world()
	DirAccess.remove_absolute(E03_SLOT)
	print("RESULTADO E16: %d verificações, %d falhas" % [checks,failures])
	quit(1 if failures else 0)
