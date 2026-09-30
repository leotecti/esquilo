extends "res://tests/slice_performance.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	var campaign = load("res://scenes/main.tscn").instantiate()
	campaign.save_enabled = false
	root.add_child(campaign)
	level = campaign.level
	process_frame.connect(sample)
	await create_timer(2).timeout
	samples.clear()
	draw_calls.clear()
	collecting = true
	await create_timer(5).timeout
	collecting = false
	samples.sort()
	draw_calls.sort()
	var report := {"environment":"Windows Compatibility 1280x720, campanha E02 com HUD e vida extra","adapter":RenderingServer.get_video_adapter_name(),"samples":samples.size(),"p50_ms":samples[int(samples.size()*.5)],"p95_ms":samples[int(samples.size()*.95)],"draw_calls_p95":draw_calls[int(draw_calls.size()*.95)]}
	var file := FileAccess.open("res://builds/performance-e02-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
