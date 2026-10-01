extends "res://tests/slice_performance.gd"

func measure(label: String) -> Dictionary:
	await create_timer(1).timeout
	samples.clear()
	draw_calls.clear()
	collecting = true
	await create_timer(3).timeout
	collecting = false
	samples.sort()
	draw_calls.sort()
	return {"scenario":label,"samples":samples.size(),"p50_ms":samples[int(samples.size()*.5)],"p95_ms":samples[int(samples.size()*.95)],"draw_calls_p95":draw_calls[int(draw_calls.size()*.95)]}

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	var campaign = load("res://scenes/main.tscn").instantiate()
	campaign.save_enabled = false
	root.add_child(campaign)
	level = campaign.level
	process_frame.connect(sample)
	var reports: Array = []
	reports.append(await measure("gameplay"))
	campaign.restart_stage()
	await process_frame
	level = campaign.level
	reports.append(await measure("apos_reinicio"))
	level.request_phase_restart()
	reports.append(await measure("confirmacao_pausada"))
	var report := {"environment":"Windows Compatibility 1280x720, campanha E03","adapter":RenderingServer.get_video_adapter_name(),"scenarios":reports}
	var file := FileAccess.open("res://builds/performance-e03-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
