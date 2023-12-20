extends Sprite2D

@onready var player: CharacterBody2D = get_parent().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = player.position.x * 0.8;
