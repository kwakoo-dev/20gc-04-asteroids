extends RigidBody2D
class_name Asteroid

@export
var asteroid_initial_force : int = 10000
var asteroid_size : Enums.AsteroidSize

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
	if collision:
		linear_velocity = linear_velocity.bounce(collision.get_normal())
		var collider = collision.get_collider()
		if collider && collider.is_in_group("ships"):
			$ShipCollide.play()

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
	$ExplosionParticles.emitting = true
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$ExplosionSound.play()
	await $ExplosionSound.finished
	SignalBus.asteroid_destroyed.emit(position, get_global_transform().get_rotation(), asteroid_size)
	queue_free()
