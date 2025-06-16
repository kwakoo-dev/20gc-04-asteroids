extends Node

@warning_ignore_start("UNUSED_SIGNAL")
signal asteroid_destroyed(last_position : Vector2, last_rotation : float, size : Enums.AsteroidSize)
signal ship_asteroid_collided
signal ship_destroyed
@warning_ignore_restore("UNUSED_SIGNAL")
