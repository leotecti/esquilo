extends "res://tests/checkpoints_e03_performance.gd"

func run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	var campaign = load("res://scenes/main.tscn").instantiate()
	campaign.save_enabled = false
	root.add_child(campaign)
	await process_frame
	level = campaign.level
	process_frame.connect(sample)
	var reports: Array = []
	reports.append(await measure("abertura_vilarejo"))
	var steps: Array = campaign.narrative.steps
	var trapped: Dictionary = steps.filter(func(step): return step.get("type")=="scene" and step.get("background")==preload("res://assets/narrative/opening_owl_trapped.png"))[0]
	var valda_trapped: Dictionary = steps.filter(func(step): return step.get("type")=="dialogue" and step.get("speaker")=="Valda")[0]
	campaign.narrative._apply_scene(trapped)
	campaign.narrative._show_dialogue(valda_trapped)
	reports.append(await measure("abertura_coruja_presa"))
	var rescued: Dictionary = steps.filter(func(step): return step.get("type")=="scene" and step.get("background")==preload("res://assets/narrative/opening_owl_rescued.png"))[0]
	var valda_rescued: Dictionary = steps.filter(func(step): return step.get("type")=="dialogue" and str(step.get("text","")).contains("Muito obrigada"))[0]
	campaign.narrative._apply_scene(rescued)
	campaign.narrative._show_dialogue(valda_rescued)
	reports.append(await measure("abertura_coruja_resgatada"))
	var report := {"environment":"Windows Compatibility 1280x720, E11","adapter":RenderingServer.get_video_adapter_name(),"scenarios":reports}
	var file := FileAccess.open("res://builds/performance-e11-windows.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
