extends Node



func playsound(sound):
	var inst = AudioStreamPlayer.new()
	inst.stream = sound
	add_child(inst)
	inst.play()
	await inst.finished
	inst.queue_free()
