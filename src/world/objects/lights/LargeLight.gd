extends Light

class_name LargeLight

func _ready():
	speedMultiplier = -0.015
	lightValue = +800

func _on_despawn_timer_timeout():
	queue_free();
