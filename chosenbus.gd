extends Button

static var pressedButton = false

@export var isCorrectBus: bool

func _pressed() -> void:
	if (isCorrectBus && !pressedButton):
		_correctBus()
	else:
		gman.endgame('You chose the wrong bus')

func _correctBus():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	if (self.name == "busR"):
		tween.tween_property($"..", "position", Vector2.RIGHT * 1200, 3).as_relative()
	else:
		tween.tween_property($"..", "position", Vector2.LEFT * 1200, 3).as_relative()
	await tween.finished
	gman.startgame()
