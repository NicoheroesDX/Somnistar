extends Light

class_name SmallLight

func _ready():
	speedMultiplier = -0.045
	lightValue = +250

func _on_despawn_timer_timeout():
	queue_free();
