extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.update_collected_light_signal.connect(refresh_light_amount)
	refresh_light_amount(0, 0)

func refresh_light_amount(newLightAmount, oldLightAmount):
	text = str(newLightAmount);
