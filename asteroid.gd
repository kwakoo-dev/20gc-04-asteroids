extends RigidBody2D
class_name Asteroid

@export
var asteroid_initial_force : int = 10000

var current_direction : Vector2 = Vector2.RIGHT
var rotation_speed : float = 1000

@onready
var wrap_margin : float = 64.0
@onready
var viewport : Vector2 = get_viewport_rect().size

func start_moving(start_direction : Vector2) -> void:
	rotation_speed = randf_range(-1, 1)
	apply_force(start_direction.normalized() * asteroid_initial_force)

func _physics_process(delta: float) -> void:
	rotate(rotation_speed * delta)
	var collision : KinematicCollision2D  = move_and_collide(current_direction * delta)
	wrap_asteroid()

func wrap_asteroid() -> void:
	position.x = wrapf(position.x, -wrap_margin, viewport.x + wrap_margin)
	position.y = wrapf(position.y, -wrap_margin, viewport.y + wrap_margin)
