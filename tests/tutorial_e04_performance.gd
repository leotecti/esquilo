extends "res://tests/checkpoints_e03_performance.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	var campaign = load("res://scenes/main.tscn").instantiate()
	campaign.start_on_map = false
	campaign.save_enabled = false
	root.add_child(campaign)
	level = campaign.level
	process_frame.connect(sample)
	var reports: Array = []
	reports.append(await measure("hud_e_dica"))
	for sign in level.contextual_help.signs:
		campaign.mark_hint_seen("sign_0_%d_%d" % [int(sign.position.x),int(sign.position.y)])
	level.contextual_help.clear()
	reports.append(await measure("hud_sem_dica"))
	level.set_paused(true)
	reports.append(await measure("menu_de_pausa"))
	var report := {"environment":"Windows Compatibility 1280x720, campanha E04","adapter":RenderingServer.get_video_adapter_name(),"scenarios":reports}
	var file := FileAccess.open("res://builds/performance-e04-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
