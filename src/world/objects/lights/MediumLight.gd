extends Light

class_name MediumLight

func _ready():
	speedMultiplier = -0.03
	lightValue = +500

func _on_despawn_timer_timeout():
	queue_free();
