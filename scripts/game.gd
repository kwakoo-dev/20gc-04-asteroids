extends Node2D

@export
var asteroid_scene : PackedScene

@onready
var spawn_point = $AsteroidSpawnPath/SpawnPoint
@onready
var ship = $Ship
@export
var max_asteroid_count = 5

func _on_spawn_timer_timeout() -> void:
	var asteroids_count : int = get_tree().get_nodes_in_group("asteroids").size()
	if asteroids_count < max_asteroid_count:
		spawn_asteroid()

func spawn_asteroid() -> void:
	spawn_point.progress_ratio = randf()
	var asteroid : Asteroid = asteroid_scene.instantiate()
	asteroid.position = spawn_point.position
	var direction : Vector2 = (ship.position - asteroid.position)
	asteroid.start_moving(direction.rotated(randf_range(-PI/2, PI/2)))
	add_child(asteroid)
