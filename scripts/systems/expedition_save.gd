extends "res://scripts/systems/world_save.gd"
const DEVICES = {4:[],5:["Tronco"],6:["Ponte"],7:[],8:[],9:["Rocha"],10:[],11:[],12:["Peso"],13:["Comporta"],14:["Tora","Roda","Engrenagem"],15:["Arena"]}
func _init() -> void:
	current_version = 2
	max_stage = 15
	global_companion = true
	path = "user://campaign.json"
	web_key = "tico.campaign.v1"

func valid(data: Variant) -> bool:
	if not data is Dictionary or not _integer(data.get("save_version"),1,2): return false
	var base: Dictionary = data.duplicate(true)
	base.save_version = 1
	if not super.valid(base): return false
	if data.save_version==2:
		if not data.has("survival") or not data.has("tutorials") or not data.has("context_hints_seen"): return false
		if not data.get("collectibles") is Dictionary or not data.collectibles.get("golden_nuts") is Dictionary: return false
		var golden: Dictionary = data.collectibles.golden_nuts
		if golden.size()>16: return false
		for id in golden:
			if not id is String or not id.is_valid_int() or str(int(id))!=id or int(id)<0 or int(id)>data.unlocked: return false
			if not valid_ids(golden[id],64): return false
		if not data.get("story") is Dictionary or not valid_ids(data.story.get("events"),256): return false
		if not data.story.get("village") is Dictionary or data.story.village.size()>64: return false
		for id in data.story.village:
			if not valid_id(id) or not data.story.village[id] is bool: return false
	if data.has("tutorials"):
		if not data.tutorials is Dictionary: return false
		for key in data.tutorials:
			if key not in preload("res://scripts/ui/contextual_help.gd").KEYS or not data.tutorials[key] is bool: return false
	if data.has("context_hints_seen"):
		if not data.context_hints_seen is Array or data.context_hints_seen.size()>128: return false
		var unique: Array = []
		for id in data.context_hints_seen:
			if not id is String or id.length()>80 or id in unique: return false
			unique.append(id)
	if data.has("survival"):
		var survival: Variant = data.survival
		if not survival is Dictionary: return false
		if not _integer(survival.get("lives"),1,99): return false
		for key in ["pending_return","replay","pipo_unlocked"]:
			if not survival.get(key) is bool: return false
		if not _integer(survival.get("return_stage"),0,12) or int(survival.return_stage)%4!=0: return false
		if survival.return_stage>data.unlocked: return false
		if not survival.get("claimed") is Array or survival.claimed.size()>16: return false
		var seen: Array = []
		for id in survival.claimed:
			if not _integer(id,0,15) or int(id) in seen: return false
			seen.append(int(id))
	for id in data.levels:
		var index := int(id)
		if index<4: continue
		var state: Dictionary = data.levels[id]
		if state.mechanisms.size()!=DEVICES[index].size(): return false
		for device in DEVICES[index]:
			if not state.mechanisms.has(device): return false
			if state.completed and not state.mechanisms[device]: return false
			if state.checkpoint and index!=15 and device!="Engrenagem" and not state.mechanisms[device]: return false
		if index==15 and state.boss_done and not state.mechanisms.Arena: return false
	return true

func valid_id(id: Variant) -> bool:
	if not id is String or id.is_empty() or id.length()>80: return false
	for character in id:
		if not character in "abcdefghijklmnopqrstuvwxyz0123456789_:-": return false
	return true

func valid_ids(ids: Variant, limit: int) -> bool:
	if not ids is Array or ids.size()>limit: return false
	var seen := {}
	for id in ids:
		if not valid_id(id) or seen.has(id): return false
		seen[id] = true
	return true

func migrate(source: Dictionary) -> Dictionary:
	var result := source.duplicate(true)
	if result.get("save_version",1)==2: return result
	result.save_version = 2
	if not result.has("survival"):
		result.survival = {"lives":3,"pending_return":false,"return_stage":0,"replay":false,"pipo_unlocked":false,"claimed":[]}
	# O acesso aos mundos posteriores também comprova o resgate no formato antigo.
	result.survival.pipo_unlocked = result.survival.pipo_unlocked or result.unlocked>=3
	for previous in result.levels.values():
		if previous.rescued: result.survival.pipo_unlocked = true
	if not result.has("tutorials"): result.tutorials = {}
	for key in preload("res://scripts/ui/contextual_help.gd").KEYS:
		if not result.tutorials.has(key): result.tutorials[key] = false
	if not result.has("context_hints_seen"): result.context_hints_seen = []
	result.collectibles = {"golden_nuts":{}}
	result.story = {"events":[],"village":{}}
	sync_story(result)
	return result

func sync_story(data: Dictionary) -> void:
	var events: Array = data.story.events
	if events.size()<256 and data.survival.pipo_unlocked and "pipo_rescued" not in events: events.append("pipo_rescued")
	for id in data.levels:
		var state: Dictionary = data.levels[id]
		for entry in [["completed", "stage_%s_completed" % id],["boss_done", "guardian_%s_calmed" % id]]:
			if events.size()<256 and state[entry[0]] and entry[1] not in events: events.append(entry[1])
