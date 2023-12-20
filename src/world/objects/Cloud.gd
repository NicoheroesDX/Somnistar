extends StaticBody2D

@onready var player = get_parent().get_node("Player")

func bounce_player():
	player.velocity.y = -400;

func _on_player_bouncer_body_entered(body):
	if (body.get_groups().has("player")):
		bounce_player();
