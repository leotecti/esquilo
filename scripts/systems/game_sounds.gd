extends Node
## Efeitos curtos originais, sintetizados em PCM; sem arquivos externos.
var _voices: Array[AudioStreamPlayer] = []
var _next: int = 0

func _ready() -> void:
	for i in 4:
		var voice := AudioStreamPlayer.new()
		voice.volume_db = -15.0
		add_child(voice)
		_voices.append(voice)

func play_notes(notes: Array, duration: float = 0.09) -> void:
	var rate: int = 22050
	var count: int = int(rate * duration)
	var data := PackedByteArray()
	data.resize(count * notes.size() * 2)
	for n in notes.size():
		for i in count:
			var t: float = float(i) / rate
			var envelope: float = minf(t / 0.008, 1.0) * maxf(0.0, 1.0 - t / duration)
			var sample: int = int(sin(TAU * float(notes[n]) * t) * envelope * 18000.0)
			data.encode_s16((n * count + i) * 2, sample)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.data = data
	_voices[_next].stream = stream
	_voices[_next].play()
	_next = (_next + 1) % _voices.size()

func _exit_tree() -> void:
	for voice in _voices:
		voice.stop()
		voice.stream = null
