extends StaticBody2D

@onready var player = get_parent().get_node("Player")

func _process(delta):
	if global_position.x < (player.global_position.x - 1000):
		queue_free()

func bounce_player():
	player.velocity.y = -400;

func _on_player_bouncer_body_entered(body):
	if (body.get_groups().has("player")):
		bounce_player();
