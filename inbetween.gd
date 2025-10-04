extends Node2D

@onready var leftlabel = $leftstation
@onready var rightlabel = $rightstation
@onready var arrow = $Arrow
@onready var player = $player
var targetpos = Vector2(0,0)
var dir = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func init()->void:
	if ord(gman.currentStation) <= ord(gman.destinationStation):
		#go right
		arrow.flip_h = false
		leftlabel.text = gman.currentStation
		rightlabel.text = gman.destinationStation
		player.global_position = Vector2(-200,885)
		targetpos = Vector2(2120,885)
	else:
		#go left
		dir = -1
		arrow.flip_h = true
		leftlabel.text = gman.destinationStation
		rightlabel.text = gman.currentStation
		player.global_position = Vector2(2120,885)
		targetpos = Vector2(-200,885)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.global_position != targetpos:
		player.global_position.x = move_toward(player.global_position.x, targetpos.x, 500*delta)
		player.global_position.y = move_toward(player.global_position.y, targetpos.y, 500*delta)
		player.rotation_degrees += 300*delta*dir
	else:
		gman.startgame()
