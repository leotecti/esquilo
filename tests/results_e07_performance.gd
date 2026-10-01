extends "res://tests/checkpoints_e03_performance.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	var campaign = load("res://scenes/main.tscn").instantiate()
	campaign.save_enabled = false
	root.add_child(campaign)
	level = campaign.level
	process_frame.connect(sample)
	var reports: Array = []
	campaign.close_map()
	level._on_exit(level.exit_marker)
	reports.append(await measure("resultado"))
	campaign.advance()
	reports.append(await measure("mapa_apos_conclusao"))
	campaign.enter_from_map(1)
	await process_frame
	reports.append(await measure("proxima_fase"))
	var report := {"environment":"Windows Compatibility 1280x720, E07","adapter":RenderingServer.get_video_adapter_name(),"scenarios":reports}
	var file := FileAccess.open("res://builds/performance-e07-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
