extends Camera2D

@onready var player: CharacterBody2D = get_parent().get_node("Player")

func _physics_process(delta):
	position.x=player.global_position.x
