extends AnimatableBody2D

var base_speed = 0
var speed = 0

@onready var player = get_parent().get_node("Player")

@onready var playerKiller = get_node("PlayerKiller")

func _physics_process(delta):
	if Global.distance > 30000:
		base_speed = 5
	elif Global.distance > 27000:
		base_speed = 4.5
	elif Global.distance > 24000:
		base_speed = 4.25
	elif Global.distance > 21000:
		base_speed = 4
	elif Global.distance > 28000:
		base_speed = 3.75
	elif Global.distance > 15000:
		base_speed = 3.5
	elif Global.distance > 12000:
		base_speed = 3.25
	elif Global.distance > 6000:
		base_speed = 3
	elif Global.distance > 3000:
		base_speed = 2.75
	else:
		base_speed = 2.5
	
	speed = base_speed + (-0.05 * Global.speed);
	move_and_collide(Vector2(speed, 0))
	
	if global_position.x < -1500:
		global_position.x = -1500
	
	for body in playerKiller.get_overlapping_bodies():
			if (body.get_groups().has("player")):
				Global.change_collected_light(-69);
				if (Global.collectedLight <= 0):
					player.die();
