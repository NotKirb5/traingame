class_name Player extends CharacterBody2D
signal laser_shot(laser_scene, location)
@export var speed = 300
@onready var muzzle = $Muzzle

var laser_scene = preload("res://scenes/laser.tscn")
@onready var shootcd = $Timer
var cantshoot = false
var shoot_cd := false



func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity= direction*speed
	#velocity.x = direction.x * speed
	#velocity.y = direction.y * speed
	# (100,100)
	move_and_slide()
	
	if Input.is_action_just_pressed('shoot') and not cantshoot:
		shoot()
		cantshoot = true
		shootcd.start()
func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)


func _on_timer_timeout() -> void:
	cantshoot = false
	
func die():
	queue_free()
