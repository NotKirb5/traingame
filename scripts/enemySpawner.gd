extends Area2D

@export var enemy_scene: PackedScene			# drag Enemy.tscn here
@export var autostart: bool = true
@export var spawn_interval: float = 1.0
@export var max_alive: int = 10

@export var player_path: NodePath				# drag your Player node here
@export var avoid_distance: float = 80.0		# minimum distance from player
@export var max_attempts: int = 10				# tries per spawn to find a safe spot

var _alive: int = 0
var _timer: Timer
var _player: Node = null

func _ready():
	randomize()
	if enemy_scene == null:
		push_warning("EnemySpawner: 'enemy_scene' is not set.")
		return

	if player_path != NodePath():
		_player = get_node_or_null(player_path)
		if _player:
			_player.connect("player_died", Callable(self, "_on_player_died"))

	_timer = Timer.new()
	_timer.wait_time = spawn_interval
	_timer.one_shot = false
	_timer.autostart = autostart
	add_child(_timer)
	_timer.timeout.connect(_on_timeout)

func _on_player_died():
	print("Spawner: Player died, stopping all spawns!")
	stop()

func _on_timeout():
	if _alive >= max_alive:
		return
	_spawn_enemy()

func _spawn_enemy():
	var cs: CollisionShape2D = $CollisionShape2D
	if cs == null or cs.shape == null:
		push_warning("EnemySpawner: Add a CollisionShape2D with RectangleShape2D or CircleShape2D.")
		return

	var player = get_node_or_null(player_path) if player_path != NodePath() else null
	var spawn_pos: Vector2 = Vector2.ZERO
	var found: bool = false

	for i in range(max_attempts):
		var local_p: Vector2 = _random_point_local(cs)
		if local_p == Vector2.ZERO:
			return
		spawn_pos = cs.to_global(local_p)

		if player == null:
			found = true
			break

		if spawn_pos.distance_to(player.global_position) >= avoid_distance:
			found = true
			break

	if not found:
		# couldn't find a safe spot this tick
		return

	var enemy := enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = spawn_pos

	_alive += 1
	enemy.tree_exited.connect(func():
		_alive = max(0, _alive - 1))

func _random_point_local(cs: CollisionShape2D) -> Vector2:
	if cs.shape is RectangleShape2D:
		var rect_shape: RectangleShape2D = cs.shape
		var ext: Vector2 = rect_shape.extents
		return Vector2(randf_range(-ext.x, ext.x), randf_range(-ext.y, ext.y))
	elif cs.shape is CircleShape2D:
		var circ_shape: CircleShape2D = cs.shape
		var r: float = circ_shape.radius
		var t: float = randf() * TAU
		var rr: float = sqrt(randf()) * r
		return Vector2(cos(t), sin(t)) * rr
	else:
		push_warning("EnemySpawner: Unsupported shape type.")
		return Vector2.ZERO

func start():
	if _timer:
		_timer.start()

func stop():
	if _timer:
		_timer.stop()

func spawn_once_now():
	_spawn_enemy()
