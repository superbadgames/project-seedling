extends KinematicBody2D

const UP : Vector2 = Vector2.UP
const GRAVITY : float = 20.0
const move_speed : float = 25.0
const jump_power : float = 500.0

onready var animatedSprite = $AnimatedSprite

var move_velocity : Vector2 = Vector2.ZERO
var can_jump : bool = true


func _ready():
	pass # Replace with function body.


func _process(delta):
	move()
	apply_gravity()
	move_and_slide(move_velocity * move_speed, UP)


func apply_gravity():
	# falling, need gravity
	if not is_on_floor():
		print("falling!")
		move_velocity.y = GRAVITY
		can_jump = false
	# on floor, maybe we jumped?
	elif not can_jump :
		can_jump = true


func move():
	if Input.is_action_pressed("move_right"):
		print("move right")
		move_velocity = Vector2.RIGHT
		animatedSprite.play("walk")
		animatedSprite.flip_h = false
	elif Input.is_action_pressed("move_left"):
		print("move left")
		move_velocity = Vector2.LEFT
		animatedSprite.play("walk")
		animatedSprite.flip_h = true
	else:
		move_velocity = Vector2.ZERO
		animatedSprite.play("idle")
	
	if Input.is_action_pressed("jump") and can_jump:
		move_velocity.y = -jump_power
		animatedSprite.play("jump")
		can_jump = false

