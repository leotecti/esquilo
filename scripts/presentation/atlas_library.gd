extends RefCounted
const DATA = preload("res://assets/slice/regions.json")
const TICO = preload("res://assets/slice/tico.png")
const PIPO = preload("res://assets/slice/pipo.png")
const PROPS = preload("res://assets/slice/props.png")
const PUSH = preload("res://assets/slice/push.png")
const RUN = preload("res://assets/slice/run.png")
static var _cache: Dictionary = {}

static func frame(atlas: String, index: int) -> AtlasTexture:
	var key := atlas + str(index)
	if not _cache.has(key):
		var texture := AtlasTexture.new()
		texture.atlas = {"tico":TICO,"pipo":PIPO,"props":PROPS,"push":PUSH,"run":RUN}[atlas]
		var r: Array = DATA.data[atlas][index]
		texture.region = Rect2(r[0],r[1],r[2],r[3])
		texture.filter_clip = true
		_cache[key] = texture
	return _cache[key]
