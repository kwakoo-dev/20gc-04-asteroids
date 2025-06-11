extends Area2D
class_name Laser

var speed = 1000

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()

func destroy() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("asteroids"):
		body.explode()
	queue_free()
