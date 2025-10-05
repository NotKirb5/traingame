## This program drifts the player to either left or right and the player input is to center it 

extends Node2D

signal game_over(reason: String)	# "fell" (red too long) or "timeout"

# --- Tuning knobs ---
@export var center_threshold: float = 50.0	# green zone width (for your sprite/color logic)
@export var center_snap: float = 8.0			# how close to center to "lock" and pick new side

@export var drift_accel: float = 40.0			# how hard it drifts by itself
@export var max_drift_speed: float = 300.0	# cap auto drift speed
@export var kick_speed: float = 60.0			# initial speed when a new drift starts

@export var input_accel: float = 200.0		# player influence strength
@export var recenter_bonus: float = 1.8		# multiplier when pushing toward center
@export var drag: float = 20.0				# mild damping so velocity doesn't explode

@export var round_time_limit: float = 30.0	# in seconds

var time_outside_threshold: float = 0.0
var was_outside_last_frame: bool = false
var stopped: bool = false
var goodSprite: String = "res://assets/player.png"           
var badSprite: String = "res://assets/tiltedplayer.png"

var startPos: Vector2
var velocityOnX: float = 0.0
var drift_dir: int = 1						# +1 → right, -1 → left
var rng := RandomNumberGenerator.new()

var outside_streak: float = 0.0				# continuous time in red
var elapsed_time: float = 0.0				# total round time
var game_over_reason: String = ""			# "fell" or "timeout"

@onready var sprite := $Sprite2D


func _ready():
	startPos = position
	rng.randomize()
	_pick_new_drift()


func _process(delta):
	if stopped:
		return

	elapsed_time += delta
	if round_time_limit > 0.0 and elapsed_time >= round_time_limit:
		_stop_movement_with_reason("timeout")
		return

	var dirOnX := position.x - startPos.x

	# --- Auto drift ---
	velocityOnX += drift_dir * drift_accel * delta
	velocityOnX = clamp(velocityOnX, -max_drift_speed, max_drift_speed)

	# --- Player input influence ---
	var input_dir := 0.0
	if Input.is_action_pressed("move_right"):
		input_dir += 1.0
	if Input.is_action_pressed("move_left"):
		input_dir -= 1.0

	if input_dir != 0.0:
		var toward_center_dir := 0.0 if dirOnX == 0.0 else -signf(dirOnX)
		var mult := recenter_bonus if (
			input_dir == toward_center_dir and toward_center_dir != 0.0
		) else 0.6
		velocityOnX += input_dir * input_accel * mult * delta

		# Optional gentle snap-assist when pushing the right way
		if toward_center_dir != 0.0 and input_dir == toward_center_dir:
			position.x = lerp(position.x, startPos.x, clamp(2.0 * delta, 0.0, 0.5))

	velocityOnX = move_toward(velocityOnX, 0.0, drag * delta)
	position.x += velocityOnX * delta

	# --- Center lock & new drift ---
	dirOnX = position.x - startPos.x
	if absf(dirOnX) <= center_snap and absf(velocityOnX) < 35.0:
		position.x = startPos.x
		velocityOnX = 0.0
		_pick_new_drift()

	# --- Track time outside threshold ---
	var is_outside = absf(dirOnX) >= center_threshold
	if is_outside:
		time_outside_threshold += delta
		was_outside_last_frame = true
		outside_streak += delta			# continuous in red
	else:
		was_outside_last_frame = false
		outside_streak = 0.0			# reset streak when green

	# --- Game over if 3s continuously in red ---
	if outside_streak >= 3.0:
		_stop_movement_with_reason("fell")
		return

	# --- Visual feedback ---
	if not is_outside:
		#sprite.scale = Vector2(0.5, 0.5)
		sprite.texture = load(goodSprite)
	else:
		#sprite.scale = Vector2(0.5, 0.5)
		print('your outside ',global_position.x)
		sprite.texture = load(badSprite)
		if global_position.x < 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true


func _pick_new_drift():
	drift_dir = -1 if rng.randi_range(0, 1) == 0 else 1
	velocityOnX = drift_dir * kick_speed

func _stop_movement():
	_stop_movement_with_reason("fell")

func _stop_movement_with_reason(reason: String):
	if stopped:
		return
	stopped = true
	velocityOnX = 0.0
	game_over_reason = reason
	gman.endgame('You fell down :(')
	print("Game Over: %s" % reason)

func get_time_outside_threshold() -> float:
	return time_outside_threshold

func get_game_over_reason() -> String:
	return game_over_reason
