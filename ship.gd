extends CharacterBody2D

var thrust_direction : Vector2 = Vector2.RIGHT
var rotation_speed : float = 4.0
var thrust_power : float = 100.0

@onready
var wrap_margin : float = ($ShiipSprite.get_rect().size.x + $ShiipSprite.get_rect().size.y) / 4.0
@onready
var viewport : Vector2 = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	var rotation_input : float = Input.get_axis("left", "right")
	thrust_direction = thrust_direction.rotated(rotation_input * delta * rotation_speed)
	rotation = thrust_direction.angle()
	if Input.is_action_pressed("accelerate"):
		velocity += thrust_power * thrust_direction * delta 
	
	
	
	move_and_slide()
	wrap_ship()

func wrap_ship() -> void:
	position.x = wrapf(position.x, -wrap_margin, viewport.x + wrap_margin)
	position.y = wrapf(position.y, -wrap_margin, viewport.y + wrap_margin)
