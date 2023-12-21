extends Sprite2D

@onready var player: CharacterBody2D = get_parent().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x = player.global_position.x * 0.8;
