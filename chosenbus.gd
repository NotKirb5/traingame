extends Button

static var pressedButton = false

@export var isCorrectBus: bool

func _pressed() -> void:
	if (isCorrectBus && !pressedButton):
		_correctBus()

func _correctBus():
	pressedButton = true
	if (self.name == "busR"):
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property($"..", "position", Vector2.RIGHT * 1200, 3).as_relative()
	else:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property($"..", "position", Vector2.LEFT * 1200, 3).as_relative()
