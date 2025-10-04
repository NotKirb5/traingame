extends Node


var games = ["res://testgame.tscn"]
@onready var hud = preload('res://hud.tscn')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startgame():
	
	get_tree().change_scene_to_file(games[0])
	var isnt = hud.instantiate()
	add_child(hud)
	get_tree().paused = true


func gamefinished():
	get_tree().change_scene_to_file("res://mainscene.tscn")
	
