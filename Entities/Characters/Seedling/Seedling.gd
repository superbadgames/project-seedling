extends KinematicBody2D

const UP : Vector2 = Vector2.UP
const GRAVITY : float = 3.0
# 100 felt too slow, 150 too fast, maybe change later when there are levels to
# test
const move_speed : float = 125.0
const jump_power : float = 100.0

onready var animatedSprite = $AnimatedSprite

var move_velocity : Vector2 = Vector2.ZERO
var can_jump : bool = true


func _process(delta):
	move()
	apply_gravity()
	# VERY IMPORTANT!
	# Without saving the return value from move_and_slide, is_on_floor will
	# in correctly return. 
	move_velocity = move_and_slide(move_velocity * move_speed, UP)


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
	# Change x and y values of move_velocity independently.
	# Compute X value
	if Input.is_action_pressed("move_right"):
		print("move right")
		move_velocity.x = Vector2.RIGHT.x
		animatedSprite.play("walk")
		animatedSprite.flip_h = false
	elif Input.is_action_pressed("move_left"):
		print("move left")
		move_velocity.x = Vector2.LEFT.x
		animatedSprite.play("walk")
		animatedSprite.flip_h = true
	else:
		move_velocity.x = Vector2.ZERO.x
		animatedSprite.play("idle")
	
	# Compute Y value
	if Input.is_action_pressed("jump") and can_jump:
		move_velocity.y = -jump_power
		animatedSprite.play("jump")
		can_jump = false

