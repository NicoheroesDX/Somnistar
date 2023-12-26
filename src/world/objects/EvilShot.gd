extends AnimatableBody2D

var speed = 666
var velocity = Vector2.ZERO

@onready var player = get_parent().get_node("Player")
@onready var sprite = get_node("Sprite2D")

func _physics_process(delta):
	position += velocity * delta
	
	var rotation_angle = velocity.angle()
	sprite.rotation = rotation_angle

func attack_player():
	player.die();

func _on_area_2d_body_entered(body):
	if (body.get_groups().has("player")):
		attack_player();

func _on_timer_timeout():
	queue_free();
