extends AnimatableBody2D

class_name Light

@onready var timer = get_node("DespawnTimer")

@onready var passiveParticles = get_node("GPUParticles2D")
@onready var collectionParticles = get_node("CollectionParticles")

var speed = 0

var speedMultiplier = -0.03
var lightValue = +500

var isCollected = false

func _process(delta):
	if global_position.x < -1000:
		queue_free()

func _physics_process(delta):
	speed = speedMultiplier * Global.speed;
	move_and_collide(Vector2(speed, 0))

func _on_player_collector_body_entered(body):
	if (body.get_groups().has("player")):
		collect()

func collect():
	if not isCollected:
		isCollected = true;
		Global.change_collected_light(lightValue);
		passiveParticles.emitting = false;
		collectionParticles.emitting = true;
		timer.start();
