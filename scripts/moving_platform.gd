extends Node2D

@export var speed: float = 80.0
@export var wait_time: float = 0.4
@export var start_offset: float = 0.0

# 🎛 Curva editable desde el inspector
@export var motion_curve: Curve

@onready var marker_a: Node2D = $A
@onready var marker_b: Node2D = $B

var p_a: Vector2
var p_b: Vector2
var _t: float = 0.0
var _dir: int = 1
var _wait: float = 0.0
var platform_velocity: Vector2 = Vector2.ZERO
var _prev_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	p_a = marker_a.global_position
	p_b = marker_b.global_position
	_prev_pos = global_position
	_t = clamp(start_offset, 0.0, 1.0)

func _physics_process(delta: float) -> void:
	if _wait > 0.0:
		_wait -= delta
	else:
		var dist: float = p_a.distance_to(p_b)
		var dt: float = (speed / max(dist, 0.001)) * delta * _dir
		_t = clamp(_t + dt, 0.0, 1.0)
		if _t == 0.0 or _t == 1.0:
			_dir *= -1
			_wait = wait_time

	# aplicar curva (si hay)
	var t: float = _t
	if motion_curve:
		t = motion_curve.sample_baked(_t)  # 0..1 → valor curvado

	var target: Vector2 = p_a.lerp(p_b, t)
	global_position = target

	platform_velocity = (global_position - _prev_pos) / delta
	_prev_pos = global_position
