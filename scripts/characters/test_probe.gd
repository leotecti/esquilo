extends CharacterBody2D
## Corpo provisório para validar input e colisões. Não é o controlador de Tico.

@export var move_speed: float = 280.0
@export var jump_velocity: float = -560.0


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	velocity.x = Input.get_axis("move_left", "move_right") * move_speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	move_and_slide()
