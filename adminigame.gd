extends Node2D

@onready var ad = preload('res://ad.tscn')
@onready var cd = $addcooldown
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cd.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ads = get_tree().get_nodes_in_group('ad')
	if len(ads) >= 10:
		gman.endgame('Too Many Ads')





func _on_addcooldown_timeout() -> void:
	var inst = ad.instantiate()
	inst.global_position = Vector2(randi_range(200,1500),randi_range(100,900))
	add_child(inst)
	cd.start()
