extends CharacterBody2D

@export
var laser_scene : PackedScene

var thrust_direction : Vector2 = Vector2.RIGHT
var rotation_speed : float = 4.0
var thrust_power : float = 200.0
var max_speed : float = 500

@onready
var wrap_margin : float = ($ShiipSprite.get_rect().size.x + $ShiipSprite.get_rect().size.y) / 4.0
@onready
var viewport : Vector2 = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	var rotation_input : float = Input.get_axis("left", "right")
	thrust_direction = thrust_direction.rotated(rotation_input * delta * rotation_speed)
	rotation = thrust_direction.angle()
	if Input.is_action_pressed("accelerate"):
		velocity = (velocity + thrust_power * thrust_direction * delta).limit_length(max_speed)
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.5
	wrap_ship()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var laser : Laser = laser_scene.instantiate()
		laser.global_position =  $Shooter.global_position
		laser.global_rotation = $Shooter.global_rotation
		get_tree().root.add_child(laser)
		$ShootSound.play()

func wrap_ship() -> void:
	position.x = wrapf(position.x, -wrap_margin, viewport.x + wrap_margin)
	position.y = wrapf(position.y, -wrap_margin, viewport.y + wrap_margin)
