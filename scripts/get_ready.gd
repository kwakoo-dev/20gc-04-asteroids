extends Control

func _ready() -> void:
	$GetReadySound.play()

func _on_timer_timeout() -> void:
	$GetReadyText.visible = not $GetReadyText.visible
