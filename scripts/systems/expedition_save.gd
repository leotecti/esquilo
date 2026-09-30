extends "res://scripts/systems/world_save.gd"
const DEVICES = {4:[],5:["Tronco"],6:["Ponte"],7:[],8:[],9:["Rocha"],10:[],11:[],12:["Peso"],13:["Comporta"],14:["Tora","Roda","Engrenagem"],15:["Arena"]}
func _init() -> void:
	max_stage = 15
	global_companion = true
	path = "user://campaign.json"
	web_key = "tico.campaign.v1"

func valid(data: Variant) -> bool:
	if not super.valid(data): return false
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
