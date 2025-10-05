extends Button

@export var isCorrectBus: bool
@export var busAnim: AnimationPlayer

func _pressed() -> void:
	if (isCorrectBus):
		_correctBus()
		

func _correctBus():
	busAnim.play($"..".name)
