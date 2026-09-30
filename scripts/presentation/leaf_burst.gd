extends Node2D
var age := 0.0
var tint := Color("ffd787")
var count := 8
var duration := 0.55

func _process(delta: float) -> void:
	age += delta
	if age >= duration:
		queue_free()
	else:
		queue_redraw()

func _draw() -> void:
	for i in count:
		var direction := Vector2.from_angle(float(i)/count*TAU)
		var point := direction*age*75 + Vector2(0,age*age*95-20)
		var color := Color(tint,1-age/duration)
		draw_circle(point,(3+i%3)*(1-age/duration),color)
