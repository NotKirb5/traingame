extends CharacterBody2D

signal player_died

@export var speed: float = 500.0	# (pixels per second)

var stopped: bool = false

func _physics_process(_delta):
	if stopped:
		return

	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1

	# Normalize for diagonal movement
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()

	if get_slide_collision_count() > 0:
		_on_collision()

func _on_collision():
	var body = get_slide_collision(0)
	var collider := body.get_collider()

	if collider.is_in_group("enemy"):
		print("enemy")
		stopped = true
		velocity = Vector2.ZERO
		print("Player collided with enemy and stopped!")
		emit_signal("player_died")

	elif collider.is_in_group("end"):
		print("finished")
		stopped = true
		velocity = Vector2.ZERO
		print("Player collided with end and stopped!")
		emit_signal("player_died")
