extends Node
## Streams pré-carregados: nenhuma síntese de PCM no caminho de gameplay.
const MUSIC = preload("res://assets/audio/slice/bosque.wav")
const EFFECTS = {
	"jump":preload("res://assets/audio/slice/jump.wav"),
	"collect":preload("res://assets/audio/slice/collect.wav"),
	"impact":preload("res://assets/audio/slice/impact.wav"),
	"hurt":preload("res://assets/audio/slice/hurt.wav"),
	"checkpoint":preload("res://assets/audio/slice/checkpoint.wav"),
	"secret":preload("res://assets/audio/slice/secret.wav"),
	"interface":preload("res://assets/audio/slice/interface.wav"),
	"switch":preload("res://assets/audio/slice/switch.wav"),
	"charge":preload("res://assets/audio/slice/charge.wav"),
	"victory":preload("res://assets/audio/slice/victory.wav"),
	"step":preload("res://assets/audio/slice/step.wav"),
	"land":preload("res://assets/audio/slice/land.wav")}
var music: AudioStreamPlayer
var voices: Array[AudioStreamPlayer] = []
var sfx_enabled := true
var _next := 0
var played: Dictionary = {}

func _ready() -> void:
	music = AudioStreamPlayer.new()
	music.stream = MUSIC.duplicate()
	music.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	music.stream.loop_begin = 0
	music.stream.loop_end = int(music.stream.get_length() * music.stream.mix_rate)
	music.volume_db = -18
	add_child(music)
	music.play()
	for i in 6:
		var voice := AudioStreamPlayer.new()
		voice.volume_db = -12
		add_child(voice)
		voices.append(voice)

func play_effect(effect: String) -> void:
	if not sfx_enabled or effect not in EFFECTS or voices.is_empty():
		return
	played[effect] = int(played.get(effect,0)) + 1
	voices[_next].stream = EFFECTS[effect]
	voices[_next].volume_db = -21 if effect == "step" else -12
	voices[_next].play()
	_next = (_next + 1) % voices.size()

func play_notes(notes: Array, _duration: float = 0.09) -> void:
	# Compatibilidade com os eventos das fases anteriores, sem duplicar seus handlers.
	var effect := "interface"
	if notes == [880,1175]: effect = "collect"
	elif notes == [262,196]: effect = "hurt"
	elif notes == [784,988,1175] or notes == [659,784,659]: effect = "secret"
	elif notes == [523,659,784,1047]: effect = "victory" if _duration > 0.1 else "checkpoint"
	elif notes == [196,392,523] or notes == [220,330]: effect = "impact"
	elif notes == [196,262] or notes == [330,440]: effect = "charge"
	elif notes == [523,784] or notes == [784,1047]: effect = "switch"
	play_effect(effect)

func configure(music_on: bool, effects_on: bool, paused: bool) -> void:
	music.volume_db = -18 if music_on else -80
	music.stream_paused = paused
	sfx_enabled = effects_on
	for voice in voices:
		voice.stream_paused = paused
		if not effects_on: voice.stop()

func _exit_tree() -> void:
	music.stop()
	music.stream = null
	for voice in voices:
		voice.stop()
		voice.stream = null
	# O mixer nativo libera o playback em sua próxima rodada, após stop().
	# No Web o áudio depende do loop do navegador; não bloquear essa thread.
	if not OS.has_feature("web"):
		OS.delay_msec(50)
