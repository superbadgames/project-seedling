extends Node


func move(velocity : Vector2) -> Vector2:
	# Change x and y values of move_velocity independently.
	# Compute X value
	if Input.is_action_pressed("move_right"):
		velocity.x = Vector2.RIGHT.x
	elif Input.is_action_pressed("move_left"):
		velocity.x = Vector2.LEFT.x
	else:
		velocity.x = Vector2.ZERO.x
	
	return velocity
