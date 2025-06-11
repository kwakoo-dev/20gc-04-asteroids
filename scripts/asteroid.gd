extends RigidBody2D
class_name Asteroid

@export
var asteroid_initial_force : int = 10000

signal asteroid_destroyed(last_rotation : float)

var current_direction : Vector2 = Vector2.RIGHT
var rotation_speed : float = 1000

@onready
var wrap_margin : float = 32.0
@onready
var viewport : Vector2 = get_viewport_rect().size

var alive = true

func start_moving(start_direction : Vector2) -> void:
	rotation_speed = randf_range(-1, 1)
	apply_force(start_direction.normalized() * asteroid_initial_force)

func _physics_process(delta: float) -> void:
	rotate(rotation_speed * delta)
	var collision : KinematicCollision2D  = move_and_collide(current_direction * delta)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	wrap_asteroid(state)

func wrap_asteroid(state: PhysicsDirectBodyState2D) -> void:
	var updated_transform = state.get_transform()
	updated_transform.origin.x = wrapf(position.x, -wrap_margin, viewport.x + wrap_margin)
	updated_transform.origin.y = wrapf(position.y, -wrap_margin, viewport.y + wrap_margin)
	state.set_transform(updated_transform)

func explode() -> void:
	if !alive:
		return
	alive = false
	$CollisionShape2D.disabled = true
	$ExplosionSound.play()
	await $ExplosionSound.finished
	asteroid_destroyed.emit(rotation)
	queue_free()
