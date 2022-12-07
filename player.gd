extends KinematicBody2D

const Unit_Size: float = 120.0;


export var linear_speed: float = 300;
export var max_jump_height_units: float = 2.25;
export var min_jump_height_units: float = 0.8;
export var jump_duration: float = 0.5;

var gravity: float
var max_jump_velocity: float

var _jumping: bool = false

onready var _max_jump_height = max_jump_height_units * Unit_Size
onready var _animated_sprite: AnimatedSprite = $AnimatedSprite
onready var _ground_detectors: Node2D = $GroundDetectors

var motion := Vector2.ZERO


func _ready():
	gravity = 2 * _max_jump_height / pow(jump_duration, 2)
	print(2 * _max_jump_height / pow(jump_duration, 2))
	
	max_jump_velocity = -sqrt(2 * gravity * _max_jump_height)
	print(sqrt(2 * gravity * _max_jump_height))
	



func _process(delta: float) -> void:
	
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	motion.x = lerp(motion.x, linear_speed * move_direction, 0.8)
	if !is_zero_approx(motion.x):
		_animated_sprite.flip_h = motion.x < 0

	var is_grounded = _is_grounded()
	if Input.is_action_just_pressed("jump") and is_grounded:
		motion.y = max_jump_velocity
		_animated_sprite.play("jump")
		_jumping = true
	elif !is_on_floor():
		motion.y += gravity * delta
		if motion.y > 0:
			_jumping = false

	
	if !is_grounded:
		if motion.y > 0 and _animated_sprite.animation != "fall":
			_animated_sprite.play("fall")
	elif !_jumping:
		if abs(motion.x) < .1:
			if _animated_sprite.animation != "idle":
				_animated_sprite.play("idle")
		else:
			if _animated_sprite.animation != "run":
				_animated_sprite.play("run")
	
	motion = move_and_slide(motion, Vector2.UP)


func _is_grounded() -> bool:
	for r in _ground_detectors.get_children():
		if r.is_colliding():
			return true
	return false





