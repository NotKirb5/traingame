extends Button

var doorsOpen = false
var offBus = false
@export var node: Sprite2D
@export var getOffBusAnim: AnimationPlayer

signal buttonPress

func _process(delta: float) -> void:
	if (Input.is_action_pressed("space_click")):
		_pressed()

func _pressed() -> void:
	if doorsOpen && !offBus:
		buttonPress.emit()
		getOffBusAnim.play("player_out_of_bus")
		offBus = true

func _on_stop() -> void:
	doorsOpen = true

func _on_timeout() -> void:
	doorsOpen = false
