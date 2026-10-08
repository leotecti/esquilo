extends CharacterBody2D
## Besouro blindado: Pipo quebra a carapaça; depois, qualquer herói finaliza.
const BALANCE = preload("res://scripts/systems/game_balance.gd")
signal stomped(enemy: Node2D)
signal armor_broken_signal(enemy: Node2D)

var level: Node2D
var origin := Vector2.ZERO
var direction := -1.0
var speed := BALANCE.BEETLE_SPEED * 0.72
var patrol_distance := 95.0
var alert := false
var defeated := false
var armored := true
var armor_broken := false
var armor_flash := 0.0
var _blocked_cooldown := 0.0

func _ready() -> void:
	origin = position
	collision_layer = 1
	collision_mask = 1
	add_to_group("enemies")
	var collision := CollisionShape2D.new()
	collision.name = "Collision"
	collision.position = Vector2(0,-20)
	var shape := RectangleShape2D.new()
	shape.size = Vector2(58,40)
	collision.shape = shape
	add_child(collision)
	var art := preload("res://scripts/presentation/enemy_art.gd").new()
	art.name = "EnemyArt"
	art.kind = "beetle"
	add_child(art)

func _physics_process(delta: float) -> void:
	if defeated or level.completed or level.respawning: return
	armor_flash = maxf(0.0,armor_flash-delta)
	_blocked_cooldown = maxf(0.0,_blocked_cooldown-delta)
	var player: CharacterBody2D = level.tico
	alert = absf(player.position.x-position.x)<230 and absf(player.position.y-position.y)<80
	if alert: direction = signf(player.position.x-position.x)
	velocity.x = direction*(BALANCE.BEETLE_ALERT_SPEED*.70 if alert else speed)
	velocity.y = minf(velocity.y+1200.0*delta,900.0)
	move_and_slide()
	if is_on_wall(): direction *= -1.0
	if absf(position.x-origin.x)>patrol_distance:
		position.x = origin.x+clampf(position.x-origin.x,-patrol_distance,patrol_distance)
		direction = -signf(position.x-origin.x)
	# A soma das larguras físicas mantém os centros a cerca de 53 px no impacto.
	# A margem de 62 px garante que o contato da investida seja lido nesse quadro.
	if absf(player.position.x-position.x)<62 and player.position.y>position.y-62 and player.position.y<position.y+28:
		if player.is_in_group("pipo") and player.ability=="charge":
			receive_charge(player)
		elif player.velocity.y>0 and player.previous_position.y<=position.y-30:
			if player.is_in_group("pipo") and get_meta("pipo_one_hit",false): receive_pipo_stomp(player)
			elif armored: _block_attack(player,"A carapaça bloqueou o pisão!")
			else: _defeat(player)
		else:
			player.take_damage(position)

func receive_charge(character: Node2D) -> bool:
	if defeated or not character.is_in_group("pipo") or character.ability!="charge": return false
	if get_meta("pipo_one_hit",false): return _defeat(character)
	if armored:
		armored = false
		armor_broken = true
		armor_flash = .35
		velocity.x = character.charge_direction*170.0
		armor_broken_signal.emit(self)
		queue_redraw()
		return true
	return _defeat(character)

func receive_pipo_stomp(character: Node2D) -> bool:
	if defeated or not get_meta("pipo_one_hit",false) or not character.is_in_group("pipo"): return false
	return _defeat(character)

func receive_tail(character: Node2D) -> bool:
	if defeated: return false
	if armored:
		_block_attack(character,"A caudada não atravessa a carapaça!")
		return false
	return _defeat(character)

func _block_attack(player: Node2D, message: String) -> void:
	if _blocked_cooldown>0: return
	_blocked_cooldown = .45
	armor_flash = .18
	if player.has_method("bounce"): player.bounce()
	if is_instance_valid(level):
		level._feedback(position,"CLANG!",Color("d8edf1"))
		level._say(message+" Troque para Pipo e use INVESTIR.")
		level.sounds.play_notes([196,147],.055)

func _defeat(player: Node2D = null) -> bool:
	if defeated: return false
	defeated = true
	if is_instance_valid(player) and player.has_method("bounce"): player.bounce()
	stomped.emit(self)
	hide()
	return true

func reset_enemy() -> void:
	position = origin
	velocity = Vector2.ZERO
	direction = -1.0
	alert = false
	defeated = false
	armored = true
	armor_broken = false
	armor_flash = 0.0
	_blocked_cooldown = 0.0
	show()
	queue_redraw()
