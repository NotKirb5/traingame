extends CharacterBody2D

@export var player_path: NodePath
@export var windup_time: float = 0.7			# time to aim before dash
@export var dash_speed: float = 600.0			# dash speed
@export var dash_max_time: float = 3.0			# safety cap for dash duration
@export var face_rotate: bool = true			# rotate to face player during windup
@export var despawn_on_finish: bool = true		# disappear after dash

var _player: Node = null
var _state: int = 0								# 0=Aim, 1=Dash
var _aim_timer: float = 0.0
var _dash_timer: float = 0.0
var _target_point: Vector2 = Vector2.ZERO
var _dash_dir: Vector2 = Vector2.ZERO

func _ready():
	if player_path != NodePath():
		_player = get_node_or_null(player_path)
	_aim_timer = windup_time
	_state = 0	# AIM

func _physics_process(delta):
	match _state:
		0:	# Aim (face player, track last known position)
			if is_instance_valid(_player):
				_target_point = (_player as Node2D).global_position
				if face_rotate:
					var to_player := _target_point - global_position
					rotation = to_player.angle()
					# optional: flip sprite instead of rotate
					# if _sprite: _sprite.flip_h = to_player.x < 0
			_aim_timer -= delta
			if _aim_timer <= 0.0:
				_start_dash()
		1:	# DASH (toward stored last-known point)
			velocity = _dash_dir * dash_speed
			move_and_slide()
			_dash_timer -= delta

			# stop if they hit time cap
			if _dash_timer <= 0.0:
				_finish_dash()

func _start_dash():
	# lock the direction toward the stored last-known point
	var to_target := _target_point - global_position
	if to_target.length() < 0.001:
		to_target = Vector2.RIGHT
	_dash_dir = to_target.normalized()
	if face_rotate:
		rotation = _dash_dir.angle()
	_state = 1
	_dash_timer = dash_max_time

func _finish_dash():
	velocity = Vector2.ZERO
	if despawn_on_finish:
		queue_free()
	else:
		_state = 0
		_aim_timer = windup_time
