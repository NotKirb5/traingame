extends CanvasLayer

@onready var timer = $Timer
@onready var timerlabel = $timerlabel
@onready var startbg = $Panel
@onready var tutolabel = $tutolabel
@onready var desinationLabel = $destinationlabel
@onready var stationLabel = $currentlabel
@onready var arrow = $Arrow
@onready var waittimer = $waittimer
@onready var waitbar = $Reds
@onready var instuct = $spaceintruct
@onready var stationtimer = $stationtimer
var dir = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startbg.show()
	tutolabel.show()
	instuct.hide()
	waitbar.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer.time_left != 0:
		timerlabel.text = str(int(timer.time_left + 1))
	
	if waittimer.time_left != 0 and Input.is_action_just_pressed('space_click'):
		if gman.currentStation == gman.destinationStation:
			gman.newgame()
		else:
			gman.endgame('You got off the wrong station')
	
	desinationLabel.text = 'Destination Station: ' + gman.destinationStation
	stationLabel.text = 'Current Station: ' + gman.currentStation
	match dir:
		-1:
			arrow.flip_h = true
		1:
			arrow.flip_h = false
		_:
			arrow.flip_h = false
	
	if waittimer.time_left != 0:
		waitbar.scale.x = waittimer.time_left/5


func _on_timer_timeout() -> void:
	startbg.hide()
	timerlabel.hide()
	tutolabel.hide()
	get_tree().paused = false
	stationtimer.start()


func setinstructions(s:String)->void:
	tutolabel.text = s


func _on_stationtimer_timeout() -> void:
	gman.currentStation = str(char(int(ord(gman.currentStation)) + dir))
	waittimer.start()
	waitbar.show()
	instuct.show()
	await waittimer.timeout
	if gman.currentStation == gman.destinationStation:
		gman.endgame('You Missed Your Stop.')
	waitbar.hide()
	instuct.hide()
	stationtimer.start()
	
	
	

func setdirection()->void:
	if ord(gman.currentStation) <= ord(gman.destinationStation):
		dir = 1
	else:
		dir = -1
