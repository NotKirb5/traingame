extends Node
@onready var player_spawn_pos = $player/PlayerSpwanPos
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@export var enemy_scenes: Array[PackedScene] = []
var lives = 3
var player = null
func _ready():
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	#player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("rest"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	add_child(laser)


func _on_enemy_spawn_timer_timeout() -> void:
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50, 500), -50)
	enemy_container.add_child(e)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		print('enemy left')
		lives -= 1
		area.queue_free()
		if lives <= 0:
			print('gameover')
