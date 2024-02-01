extends KinematicBody2D

const UP : Vector2 = Vector2.UP
const GRAVITY : float = 200.0
const JUMP_GRAVITY : float = 50.0
const TERMINAL_VELOCITY : float = 1_000.0
const FAIL_PLANE : float = 5_000.0
# Max speed the velocity can reach from acceleration
# X values
const walk_max_speed : float = 250.0
const run_max_speed : float = 600.0
const air_max_speed : float = 1_000.0
# Y value
const jump_max_speed : float = 2_500.0
# These are the acceleration values. These are appliec to the velocity each fram
# to move the player
# X values
const walk_accel : float = 50.0
const run_accel : float = 75.0
const air_accel : float = 30.0
# Y Values
const jump_accel : float = 800.0
const initial_jump_force : float = 500.0
# Rate of slow down, while on the ground
const ground_decel : float = 75.0 
const air_decel : float = 50.0

onready var animatedSprite = $AnimatedSprite
onready var movement = $Movement

var move_velocity : Vector2 = Vector2.ZERO
var can_jump : bool = true
var jumping : bool = false
var in_air : bool = false


func _physics_process(delta):
	move()
	jump()
	animate()
	move_and_slide(move_velocity, UP)
	apply_gravity()


# Consider moving a lot of this into the move object. This could be shared maybe.
func move():
	if Input.is_action_pressed("move_right"):
		print("move right!")
		if not in_air:
			if Input.is_action_pressed("action"):
				move_velocity.x += run_accel
				if move_velocity.x >= run_max_speed: 
					move_velocity.x = run_max_speed
			else:
				move_velocity.x += walk_accel
				if move_velocity.x >= walk_max_speed:
					move_velocity.x = walk_max_speed
		elif in_air:
			move_velocity.x += air_accel
			if move_velocity.x > air_max_speed:
				move_velocity.x = air_max_speed
	elif Input.is_action_pressed("move_left"):
		if not in_air:
			if Input.is_action_pressed("action"):
				move_velocity.x -= run_accel
				if move_velocity.x <= -run_max_speed: 
					move_velocity.x = -run_max_speed
			else:
				move_velocity.x -= walk_accel
				if move_velocity.x <= -walk_max_speed:
					move_velocity.x = -walk_max_speed
	else:
		if not in_air:
			if move_velocity.x > 0:
				move_velocity.x -= ground_decel
			elif move_velocity.x < 0:
				move_velocity.x += ground_decel
			
			if move_velocity.x <= ground_decel and move_velocity.x >= -ground_decel:
				move_velocity.x = 0
		elif in_air:
			if move_velocity.x > 0:
				move_velocity.x -= air_decel
			elif move_velocity.x < 0:
				move_velocity.x += air_decel


func jump():
	if Input.is_action_just_pressed("jump"):
		if can_jump and not in_air:
			can_jump = false
			jumping = true
			move_velocity.y = -initial_jump_force
	elif Input.is_action_pressed("jump") and jumping:
		move_velocity.y -= jump_accel
		if move_velocity.y <= -jump_max_speed:
			jumping = false
	
	if Input.is_action_just_released("jump"):
		jumping = false


func apply_gravity():
	# falling, need gravity
	if not is_on_floor():
		if jumping:
			move_velocity.y += JUMP_GRAVITY
		else:
			move_velocity.y += GRAVITY
		in_air = true
	# on floor. For testing we can jump. This needs to change soon
	else:
		can_jump = true
		in_air = false


func animate():
	if Input.is_action_pressed("move_right") :
		animatedSprite.play("walk")
		animatedSprite.flip_h = false
	elif Input.is_action_pressed("move_left"):
		animatedSprite.play("walk")
		animatedSprite.flip_h = true
	else:
		animatedSprite.play("idle")
	
	if Input.is_action_pressed("jump") :
		animatedSprite.play("jump")
