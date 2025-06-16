extends ProgressBar

func _ready() -> void:
	SignalBus.ship_asteroid_collided.connect(_on_asteroid_collision)

func _on_asteroid_collision() -> void:
	value -= 10
	if value == 0:
		SignalBus.ship_destroyed.emit()
