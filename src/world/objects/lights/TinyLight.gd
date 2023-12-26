extends Light

class_name TinyLight

func _ready():
	speedMultiplier = -0.06
	lightValue = +100

func _on_despawn_timer_timeout():
	queue_free();
