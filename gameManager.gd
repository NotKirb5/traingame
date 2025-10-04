extends Node

var currentStation = 'A'
var destinationStation = 'C'

var games = {
	"res://testgame.tscn": 'A test game for us'
}
@onready var hud = preload('res://hud.tscn')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startgame():
	var randomkey = games.keys()[randi_range(0,len(games.keys())-1)]
	get_tree().change_scene_to_file(randomkey)
	var inst = hud.instantiate()
	add_child(inst)
	inst.setdirection()
	inst.setinstructions(games[randomkey])
	get_tree().paused = true


func newgame():
	get_tree().get_first_node_in_group('hud').queue_free()
	get_tree().change_scene_to_file("res://inbetween.tscn")
	
	var stations = []
	for i in range(ord('A'),ord('G') + 1):
		stations.append(char(i))
	stations.erase(currentStation)
	print(stations)
	destinationStation = stations[randi_range(0,len(stations)-1)]
	await get_tree().scene_changed
	get_tree().current_scene.init()
	

func endgame(reason:String)->void:
	get_tree().change_scene_to_file("res://gameover.tscn")
	await get_tree().scene_changed
	var hud = get_tree().get_first_node_in_group('hud')
	if hud != null:
		hud.queue_free()
	get_tree().current_scene.setreason(reason)


func newstation()->void:
	
	get_tree().get_first_node_in_group('hud').queue_free()
	
	get_tree().change_scene_to_file("res://inbetween.tscn")
