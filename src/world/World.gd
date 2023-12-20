extends Node2D

@onready var player: CharacterBody2D = get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.y > 400:
		player.position.y = 0
		player.velocity = Vector2(0,0)
