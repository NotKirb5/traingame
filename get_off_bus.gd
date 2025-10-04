extends Button

var doorsOpen = false
var offBus = false
var thankable = false
@export var node: Sprite2D
@export var getOffBusAnim: AnimationPlayer
@export var thanksBubble: Sprite2D
@onready var cooldown: Timer = $Timer

signal buttonPress

func _process(delta: float) -> void:
	if (Input.is_action_pressed("space_click") && !offBus):
		_pressed()
		cooldown.start()
	elif (Input.is_action_pressed("space_click") && thankable):
		_thank_bus_driver()

func _make_thankable() -> void:
	thankable = true

func _thank_bus_driver() -> void:
	thanksBubble.visible = true

func _pressed() -> void:
	if doorsOpen && !offBus:
		buttonPress.emit()
		getOffBusAnim.play("player_out_of_bus")
		offBus = true

func _on_stop() -> void:
	doorsOpen = true

func _on_timeout() -> void:
	doorsOpen = false
