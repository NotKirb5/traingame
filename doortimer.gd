extends Timer

@export var slider: HSlider
@onready var bus = $"../Bus"


func _ready() -> void:
	slider.value = 0


func _on_stop() -> void:
	wait_time = bus.crowdedness * 20
	slider.max_value = wait_time
	start()
	
func _process(delta: float) -> void:
	slider.value = wait_time - time_left
