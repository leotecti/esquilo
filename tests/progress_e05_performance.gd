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
	var gameplay := await measure("hud_e_dica_v2")
	# Mede serialização e validação; não altera o save real do jogador.
	var started := Time.get_ticks_usec()
	for i in 100:
		campaign.save_progress()
		campaign.store.valid(campaign.data)
		campaign.progress_summary()
	var report := {"environment":"Windows Compatibility 1280x720, E05","adapter":RenderingServer.get_video_adapter_name(),
		"gameplay":gameplay,"progress_validation_summary_mean_ms":(Time.get_ticks_usec()-started)/100000.0}
	var file := FileAccess.open("res://builds/performance-e05-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
