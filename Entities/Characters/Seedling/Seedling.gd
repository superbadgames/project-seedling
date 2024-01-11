extends KinematicBody2D

const UP : Vector2 = Vector2.UP
const GRAVITY : float = 3.0
# 100 felt too slow, 150 too fast, maybe change later when there are levels to
# test
const move_speed : float = 125.0
const jump_power : float = 100.0

onready var animatedSprite = $AnimatedSprite
onready var movement = $Movement

var move_velocity : Vector2 = Vector2.ZERO
var can_jump : bool = true


func _process(delta):
	move_velocity = movement.move(move_velocity)
	jump_check()
	apply_gravity()
	animate()
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

func jump_check():
	# Compute Y value
	if Input.is_action_pressed("jump") and can_jump:
		move_velocity.y = -jump_power
		can_jump = false


func animate():
	if move_velocity.x != 0 :
		animatedSprite.play("walk")
		# false == moving right
		# true == moving left
		if move_velocity.x > 0:
			animatedSprite.flip_h = false
		elif move_velocity.x < 0: 
			animatedSprite.flip_h = true
	if move_velocity.y < 0 :
		animatedSprite.play("jump")
	if move_velocity == Vector2.ZERO:
		animatedSprite.play("idle")
