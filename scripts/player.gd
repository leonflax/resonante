extends CharacterBody2D

const SPEED: float = 80.0
const JUMP_VELOCITY: float = -380.0
const BASE_FPS: float = 12.0

const ANIM_IDLE := "idle"
const ANIM_WALK := "walk"
const ANIM_JUMP := "jump"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var jump_locked := false
var jump_anim_fired := false

func _physics_process(delta: float) -> void:
	# Gravedad original
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# reset flags al pisar
		jump_locked = false
		jump_anim_fired = false
		if velocity.y > 0.0:
			velocity.y = 0.0

	# SALTO (debug)
	if Input.is_action_just_pressed("jump"):
		print("[DBG] just_pressed jump. on_floor=", is_on_floor())
	if Input.is_action_just_pressed("jump") and is_on_floor() and not jump_locked:
		print("[DBG] SALTO DISPARADO")
		velocity.y = JUMP_VELOCITY
		jump_locked = true
		if not jump_anim_fired:
			if animated_sprite.animation != ANIM_JUMP:
				print("[DBG] play anim jump")
				animated_sprite.play(ANIM_JUMP)
			animated_sprite.speed_scale = 1.0
			jump_anim_fired = true

	var direction: float = Input.get_axis("move_left", "move_right")

	# Flip
	if direction > 0.0:
		animated_sprite.flip_h = false
	elif direction < 0.0:
		animated_sprite.flip_h = true

	# Movimiento horizontal
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0.0

	# Animaciones en piso
	if is_on_floor():
		if absf(velocity.x) < 0.5:
			if animated_sprite.animation != ANIM_IDLE and not jump_anim_fired:
				animated_sprite.play(ANIM_IDLE)
			animated_sprite.speed_scale = 1.0
		else:
			if animated_sprite.animation != ANIM_WALK and not jump_anim_fired:
				animated_sprite.play(ANIM_WALK)
			animated_sprite.speed_scale = clamp(absf(velocity.x) / SPEED, 0.3, 2.0)
	# En el aire: no re-disparar jump
	# (Si querés, agregá una anim 'fall' al detectar velocity.y > 0)

	move_and_slide()
