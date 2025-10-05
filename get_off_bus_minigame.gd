
extends Node2D
var doorsOpen = false
var offBus = false
@onready var getOffBusAnim: AnimationPlayer = $AnimationPlayer
@onready var stoptimer = $TimerToDoorOpen
signal buttonPress

func _process(delta: float) -> void:
	if (Input.is_action_pressed("space_click")):
		_on_button_pressed()

func _pressed() -> void:
	pass

func _on_stop() -> void:
	doorsOpen = true

func _on_timeout() -> void:
	doorsOpen = false


func _on_button_pressed() -> void:
	if doorsOpen && !offBus:
		buttonPress.emit()
		getOffBusAnim.play("player_out_of_bus")
		offBus = true
		stoptimer.paused = true
		await getOffBusAnim.animation_finished
		gman.between()


func _on_timer_to_stop_timeout() -> void:
	doorsOpen = true


func _on_timer_to_door_open_timeout() -> void:
	gman.endgame('Missed Your Stop')
