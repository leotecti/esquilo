extends "res://scripts/systems/save_manager.gd"
var max_stage := 3
var global_companion := false
var item_limit := 64
## Slot separado: mantém intacta a aventura do protótipo.
func _init() -> void:
	path = "user://world1.json"
	web_key = "tico.world1.v1"

func valid(data: Variant) -> bool:
	if not data is Dictionary or data.get("save_version") != 1:
		return false
	if not _integer(data.get("stage"),0,max_stage) or not _integer(data.get("unlocked"),0,max_stage):
		return false
	if data.stage > data.unlocked or not data.get("finished") is bool:
		return false
	if data.finished and data.unlocked != max_stage:
		return false
	if not data.get("settings") is Dictionary:
		return false
	for key in ["music","effects"]:
		if not data.settings.get(key) is bool: return false
	if not data.get("levels") is Dictionary or data.levels.size() > max_stage+1:
		return false
	if not data.levels.has(str(int(data.stage))): return false
	for previous in int(data.unlocked):
		var state: Variant = data.levels.get(str(previous))
		if not state is Dictionary or state.get("completed") != true: return false
	if data.finished:
		var final_state: Variant = data.levels.get(str(max_stage))
		if not final_state is Dictionary or final_state.get("completed") != true: return false
	for id in data.levels:
		if not id is String or not id.is_valid_int() or str(int(id)) != id or int(id)<0 or int(id)>data.unlocked: return false
		var state: Variant = data.levels[id]
		if not state is Dictionary: return false
		for key in ["checkpoint","completed","rescued","gate","heavy","secret","boss_done"]:
			if not state.get(key) is bool: return false
		if state.get("character") not in ["Tico","Pipo"]: return false
		if state.character == "Pipo" and not state.rescued: return false
		if not global_companion and id in ["0","1"] and state.rescued: return false
		if int(id)>=3 and not state.rescued: return false
		if not _number(state.get("stone"),850,1190): return false
		if state.gate and state.stone < 1110: return false
		if id == "2" and state.checkpoint and not (state.rescued and state.gate and state.heavy): return false
		if id == "2" and state.completed and not state.rescued: return false
		if int(id)%4 == 3 and state.completed and not state.boss_done: return false
		if int(id)>=4:
			if not state.get("mechanisms") is Dictionary or state.mechanisms.size()>32: return false
			for key in state.mechanisms:
				if not key is String or key.length()>64 or not state.mechanisms[key] is bool: return false
		for key in ["items","blocks"]:
			if not state.get(key) is Array or state[key].size() > item_limit: return false
			for item in state[key]:
				if not item is String or item.length() > 80: return false
	return true

func _number(value: Variant, low: float, high: float) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value >= low and value <= high

func _integer(value: Variant, low: int, high: int) -> bool:
	return _number(value,low,high) and float(value) == floorf(float(value))
