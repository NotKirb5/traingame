extends Sprite2D

@export var crowdedness: float

signal stop

func _stop() -> void:
	stop.emit()
