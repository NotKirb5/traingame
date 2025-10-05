extends Node2D

@onready var resultlabel = $reason
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setreason(reson:String) -> void:
	resultlabel.text = reson


func _on_button_pressed() -> void:
	gman.startgame()
