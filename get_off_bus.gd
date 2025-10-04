extends Button

var b = true
	
func _pressed() -> void:
	print(b)

func _on_timeout() -> void:
	b = false
