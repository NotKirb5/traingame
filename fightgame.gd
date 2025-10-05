extends Node2D



var punching = false
var dead = false
@onready var playersprite = $player/Sprite2D
@onready var enemysprite = $enemy/Sprite2D
@onready var cd = $cd
var health = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("punch") and not punching:
		playersprite.set_animation("punch")
		if not dead:
			enemysprite.set_animation("punched")
		
		health -= 1
		if health <= 0:
			dead = true
			enemysprite.set_animation('dead')
		punching = true
		cd.start()
		
		


func _on_cd_timeout() -> void:
	punching = false
	playersprite.set_animation("default")
	if not dead:
		enemysprite.set_animation("default")
	
