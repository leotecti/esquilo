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
	reports.append(await measure("mapa_bosque"))
	campaign.world_map.select_world(2)
	reports.append(await measure("mapa_montanha"))
	campaign.enter_from_map(0)
	reports.append(await measure("fase_apos_mapa"))
	var report := {"environment":"Windows Compatibility 1280x720, E06","adapter":RenderingServer.get_video_adapter_name(),"scenarios":reports}
	var file := FileAccess.open("res://builds/performance-e06-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
