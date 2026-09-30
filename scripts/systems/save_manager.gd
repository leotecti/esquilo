extends RefCounted
## Slot local versionado. Web usa escrita síncrona para sobreviver ao fechamento.
const VERSION := 1
const WEB_KEY := "tico.progress.v1"
var path := "user://progress.json"
var state := "empty"
var locked := false

func read_save() -> Dictionary:
	var raw := ""
	if OS.has_feature("web"):
		var result = JavaScriptBridge.eval("(function(){try{return localStorage.getItem('" + WEB_KEY + "') || '';}catch(e){return null;}})()")
		if result == null:
			state = "unavailable"
			return {}
		raw = str(result)
	elif FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			state = "unavailable"
			locked = true
			return {}
		raw = file.get_as_text()
	if raw.is_empty():
		state = "empty"
		return {}
	var json := JSON.new()
	var decoded: Variant = json.data if json.parse(raw) == OK else null
	if not valid(decoded):
		var version: Variant = decoded.get("save_version", 0) if decoded is Dictionary else 0
		state = "incompatible" if (version is int or version is float) and version > VERSION else "damaged"
		locked = true
		return {}
	state = "loaded"
	return decoded

func valid(data: Variant) -> bool:
	if not data is Dictionary:
		return false
	var version: Variant = data.get("save_version")
	if not (version is int or version is float) or version != VERSION:
		return false
	if not data.get("level") is String or data.level != "prototype_1":
		return false
	for key in ["checkpoint", "gate", "heavy", "secret", "completed"]:
		if not data.get(key) is bool:
			return false
	if data.get("character") not in ["Tico", "Pipo"]:
		return false
	var stone = data.get("stone")
	if not (stone is float or stone is int) or not is_finite(float(stone)) or stone < 850 or stone > 1191:
		return false
	if data.gate and stone < 1110:
		return false
	if data.checkpoint and not (data.gate and data.heavy):
		return false
	for key in ["items", "blocks"]:
		if not data.get(key) is Array or data[key].size() > 64:
			return false
		for id in data[key]:
			if not id is String or id.length() > 80:
				return false
	# Campo opcional aditivo: saves da etapa 6 continuam válidos.
	if data.has("settings"):
		if not data.settings is Dictionary:
			return false
		for key in ["music", "effects"]:
			if not data.settings.get(key) is bool:
				return false
	return true

func write_save(data: Dictionary) -> bool:
	if locked or not valid(data):
		return false
	var raw := JSON.stringify(data)
	var ok := false
	if OS.has_feature("web"):
		ok = bool(JavaScriptBridge.eval("(function(){try{localStorage.setItem('" + WEB_KEY + "'," + JSON.stringify(raw) + ");return true;}catch(e){return false;}})()"))
	else:
		var file := FileAccess.open(path + ".tmp", FileAccess.WRITE)
		if file != null:
			file.store_string(raw)
			file.flush()
			ok = file.get_error() == OK
			file.close()
			if ok:
				ok = DirAccess.rename_absolute(path + ".tmp", path) == OK
	state = "saved" if ok else "unavailable"
	return ok
