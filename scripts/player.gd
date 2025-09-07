extends CharacterBody2D

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -300.0

# Tu "run" tiene 13 frames y lo seteaste a 12 fps en el SpriteFrames.
const BASE_FPS: float = 12.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: float = Input.get_axis("move_left", "move_right")

	# Flip
	if direction > 0.0:
		animated_sprite.flip_h = false
	elif direction < 0.0:
		animated_sprite.flip_h = true

	# Movimiento en X
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	# Elegir animación + sincronía con velocidad real
	if is_on_floor():
		if absf(velocity.x) < 1.0:
			if animated_sprite.animation != "Idle":
				animated_sprite.play("Idle")
			animated_sprite.speed_scale = 1.0
		else:
			if animated_sprite.animation != "walkd":
				animated_sprite.play("walkd")
			# a SPEED → speed_scale = 1.0 (la animación corre a BASE_FPS)
			animated_sprite.speed_scale = clamp(absf(velocity.x) / SPEED, 0.3, 2.0)
	else:
		if animated_sprite.animation != "jump":
			animated_sprite.play("jump")
		animated_sprite.speed_scale = 1.0

	move_and_slide()
