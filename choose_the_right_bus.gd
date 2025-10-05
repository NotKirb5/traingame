extends Node2D

@onready var destlabel = $lineinfo
@onready var lbus = $busL/busL
@onready var rbus = $busR/busR
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init()->void:
	destlabel.text = gman.currentStation + ' to ' + gman.destinationStation
	if ord(gman.currentStation) <= ord(gman.destinationStation):
		rbus.isCorrectBus = true
		
	else:
		lbus.isCorrectBus = true
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
