extends "res://tests/checkpoints_e03_performance.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	var campaign = load("res://scenes/main.tscn").instantiate()
	campaign.save_enabled = false
	root.add_child(campaign)
	level = campaign.level
	process_frame.connect(sample)
	campaign.close_map()
	var reports: Array = []
	reports.append(await measure("trilha_principal"))
	level.optional_area.travel(true)
	await create_timer(.5).timeout
	reports.append(await measure("copa_opcional"))
	level.tico.reset_at(level.optional_area.location(Vector2(8580,455)))
	level.camera.snap_to_target()
	reports.append(await measure("copa_ampliada"))
	level.optional_area.travel(false)
	await create_timer(.5).timeout
	reports.append(await measure("retorno_da_copa"))
	level.tico.reset_at(Vector2(41500,545))
	level.camera.snap_to_target()
	reports.append(await measure("novo_final_da_trilha"))
	var report := {"environment":"Windows Compatibility 1280x720, E08","adapter":RenderingServer.get_video_adapter_name(),"scenarios":reports}
	var file := FileAccess.open("res://builds/performance-e08-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
