extends Node2D

@onready var player: CharacterBody2D = get_node("Player")

@onready var bgA: Sprite2D = get_node("BackgroundA");
@onready var bgB: Sprite2D = get_node("BackgroundB");

func _physics_process(delta):
	if (bgA.position.x < -1920):
		bgA.position.x = 0;
		bgB.position.x = 1920;

	var speed = Global.speed;
	bgA.position.x -= speed * delta
	bgB.position.x -= speed * delta
	

func _on_death_zone_body_entered(body):
	if (body.get_groups().has("player")):
		player.die();

func _on_spawn_emitter_body_entered(body):
	if (body.get_groups().has("spawner")):
		body.spawn_and_reset();
