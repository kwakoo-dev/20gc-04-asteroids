extends Node2D

@export
var asteroid_scene_big : PackedScene
@export
var asteroid_scene_medium : PackedScene
@export
var asteroid_scene_small : PackedScene
@export
var explosion_scene : PackedScene

@onready
var spawn_point = $AsteroidSpawnPath/SpawnPoint
@onready
var ship = $Ship
@export
var max_asteroid_count = 3

var level : int = 1
var asteroids_destroyed : int = 0
var score : int = 0

func _ready() -> void:
	SignalBus.asteroid_destroyed.connect(_on_asteroid_destroyed)
	get_tree().paused = true

func _on_get_ready_timer_timeout() -> void:
	$GetReady.visible = false
	get_tree().paused = false

func _on_asteroid_destroyed(last_position : Vector2, last_rotation : float, size : Enums.AsteroidSize) -> void:
	asteroids_destroyed += 1
	$SidePanel/LevelUpProgress.value += 10
	match size:
		Enums.AsteroidSize.BIG:
			score += 100
			spawn_medium_asteroid(last_position, last_rotation)
		Enums.AsteroidSize.MEDIUM:
			score += 200
			spawn_small_asteroid(last_position, last_rotation)
		Enums.AsteroidSize.SMALL:
			score += 400
	$SidePanel/ScoreLabel.text = str(score)

func _on_spawn_timer_timeout() -> void:
	var asteroids_count : int = get_tree().get_nodes_in_group("asteroids").size()
	if asteroids_count < max_asteroid_count:
		spawn_big_asteroid()
	
func spawn_big_asteroid() -> void:
	spawn_point.progress_ratio = randf()
	var direction : Vector2 = (ship.position - spawn_point.position).rotated(randf_range(-PI/2, PI/2))
	var asteroid : Asteroid = create_asteroid(Enums.AsteroidSize.BIG, spawn_point.position, direction)
	add_child(asteroid)
	$AsteroidSpawnSound.play()

func spawn_medium_asteroid(last_position : Vector2, last_rotation : float) -> void:
	var new_rotation_1 = Vector2.from_angle(last_rotation).rotated(deg_to_rad(135))
	var new_rotation_2 = Vector2.from_angle(last_rotation).rotated(deg_to_rad(-135))
	var asteroid_1 : Asteroid = create_asteroid(Enums.AsteroidSize.MEDIUM, last_position, new_rotation_1)
	var asteroid_2 : Asteroid = create_asteroid(Enums.AsteroidSize.MEDIUM, last_position, new_rotation_2)
	add_child(asteroid_1)
	add_child(asteroid_2)
	
func spawn_small_asteroid(last_position : Vector2, last_rotation : float) -> void:
	var new_rotation_1 = Vector2.from_angle(last_rotation).rotated(deg_to_rad(135))
	var new_rotation_2 = Vector2.from_angle(last_rotation).rotated(deg_to_rad(-135))
	var asteroid_1 : Asteroid = create_asteroid(Enums.AsteroidSize.SMALL, last_position, new_rotation_1)
	var asteroid_2 : Asteroid = create_asteroid(Enums.AsteroidSize.SMALL, last_position, new_rotation_2)
	add_child(asteroid_1)
	add_child(asteroid_2)

func create_asteroid(asteroid_size : Enums.AsteroidSize, new_position : Vector2, direction : Vector2) -> Asteroid:
	var asteroid : Asteroid = instantiate_asteroid(asteroid_size)
	asteroid.position = new_position
	asteroid.asteroid_size = asteroid_size
	asteroid.start_moving(direction)
	return asteroid

func instantiate_asteroid(asteroid_size : Enums.AsteroidSize) -> Asteroid:
	match asteroid_size:
		Enums.AsteroidSize.BIG:
			return asteroid_scene_big.instantiate()
		Enums.AsteroidSize.MEDIUM:
			return asteroid_scene_medium.instantiate()
		Enums.AsteroidSize.SMALL:
			return asteroid_scene_small.instantiate()
		_:
			push_error("Unknown value of Enums.AsteroidSize: " + str(asteroid_size))
			return asteroid_scene_big.instantiate()


func _on_level_up_progress_value_changed(value: float) -> void:
	if value >= 100:
		level += 1
		max_asteroid_count += 1
		$SidePanel/LevelUpProgress.value = 0
		$SidePanel/LevelUpProgress/Level.text = "LEVEL " + str(level)
