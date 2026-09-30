extends "res://tests/slice_performance.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	process_frame.connect(sample)
	var reports: Array = []
	for scene in ["world_2_1","world_3_1","world_4_1","world_4_guardian"]:
		level = load("res://scenes/levels/"+scene+".tscn").instantiate()
		root.add_child(level)
		level.tico.reset_at(Vector2(2520,760))
		level.camera.snap_to_target()
		await create_timer(2).timeout
		samples.clear()
		draw_calls.clear()
		collecting = true
		for i in 6: level.puff(Vector2(2520,740),Color("efca77"),10)
		await create_timer(3).timeout
		collecting = false
		samples.sort()
		draw_calls.sort()
		reports.append({"scene":scene,"samples":samples.size(),"p50_ms":samples[int(samples.size()*.5)],"p95_ms":samples[int(samples.size()*.95)],"draw_calls_p95":draw_calls[int(draw_calls.size()*.95)]})
		level.queue_free()
		await process_frame
		await create_timer(0.15).timeout
	var result := {"environment":"Windows Compatibility 1280x720","adapter":RenderingServer.get_video_adapter_name(),"levels":reports}
	var file := FileAccess.open("res://builds/performance-stage9-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(result,"\t"))
	file.close()
	print(JSON.stringify(result))
	quit()
