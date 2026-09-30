extends "res://scripts/systems/world_save.gd"
const DEVICES = {4:[],5:["Tronco"],6:["Ponte"],7:[],8:[],9:["Rocha"],10:[],11:[],12:["Peso"],13:["Comporta"],14:["Tora","Roda","Engrenagem"],15:["Arena"]}
func _init() -> void:
	max_stage = 15
	path = "user://campaign.json"
	web_key = "tico.campaign.v1"

func valid(data: Variant) -> bool:
	if not super.valid(data): return false
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
