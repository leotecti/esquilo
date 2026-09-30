extends SceneTree
var samples: Array[float] = []
var draw_calls: Array[float] = []
var level: Node2D
var previous: int
var collecting := false

func _initialize() -> void:
	call_deferred("run")

func sample() -> void:
	var now := Time.get_ticks_usec()
	if collecting:
		samples.append((now-previous)/1000.0)
		draw_calls.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	previous = now

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	level = load("res://scenes/levels/vertical_slice.tscn").instantiate()
	level.save_enabled = false
	root.add_child(level)
	process_frame.connect(sample)
	await create_timer(2).timeout
	for point in [Vector2(350,760),Vector2(1250,760),Vector2(3050,760)]:
		level.tico.reset_at(point)
		level.camera.snap_to_target()
		await create_timer(0.5).timeout
		collecting = true
		for i in 6:
			level.puff(point,Color("efca77"),10)
		await create_timer(3).timeout
		collecting = false
	samples.sort()
	draw_calls.sort()
	var result := {"environment":"Windows Compatibility 1280x720",
		"adapter":RenderingServer.get_video_adapter_name(),"samples":samples.size(),
		"p50_ms":samples[int(samples.size()*.5)],"p95_ms":samples[int(samples.size()*.95)],
		"draw_calls_p95":draw_calls[int(draw_calls.size()*.95)]}
	var file := FileAccess.open("res://builds/performance-stage7-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(result,"\t"))
	file.close()
	print(JSON.stringify(result))
	level.queue_free()
	await process_frame
	await create_timer(0.15).timeout
	quit()
