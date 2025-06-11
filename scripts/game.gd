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
var max_asteroid_count = 5

func _on_spawn_timer_timeout() -> void:
	var asteroids_count : int = get_tree().get_nodes_in_group("asteroids").size()
	if asteroids_count < max_asteroid_count:
		spawn_big_asteroid()
	
func spawn_big_asteroid() -> void:
	spawn_point.progress_ratio = randf()
	var direction : Vector2 = (ship.position - spawn_point.position).rotated(randf_range(-PI/2, PI/2))
	var asteroid : Asteroid = create_asteroid(asteroid_scene_big, spawn_point.position, direction, spawn_medium_asteroid)
	add_child(asteroid)

func spawn_medium_asteroid(last_position : Vector2, last_rotation : float) -> void:
	var new_rotation_1 = Vector2.from_angle(last_rotation).rotated(deg_to_rad(135))
	var new_rotation_2 = Vector2.from_angle(last_rotation).rotated(deg_to_rad(-135))
	var asteroid_1 : Asteroid = create_asteroid(asteroid_scene_medium, last_position, new_rotation_1, spawn_small_asteroid)
	var asteroid_2 : Asteroid = create_asteroid(asteroid_scene_medium, last_position, new_rotation_2, spawn_small_asteroid)
	add_child(asteroid_1)
	add_child(asteroid_2)
	
func spawn_small_asteroid(last_position : Vector2, last_rotation : float) -> void:
	var new_rotation_1 = Vector2.from_angle(last_rotation).rotated(deg_to_rad(135))
	var new_rotation_2 = Vector2.from_angle(last_rotation).rotated(deg_to_rad(-135))
	var asteroid_1 : Asteroid = create_asteroid(asteroid_scene_small, last_position, new_rotation_1)
	var asteroid_2 : Asteroid = create_asteroid(asteroid_scene_small, last_position, new_rotation_2)
	add_child(asteroid_1)
	add_child(asteroid_2)

func create_asteroid(asteroid_scene : PackedScene, new_position : Vector2, direction : Vector2, destroyed_callback : Callable = Callable()) -> Asteroid:
	var asteroid : Asteroid = asteroid_scene.instantiate()
	asteroid.position = new_position
	if destroyed_callback:
		asteroid.asteroid_destroyed.connect(destroyed_callback)
	asteroid.start_moving(direction)
	return asteroid
