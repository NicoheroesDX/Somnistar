extends AnimatableBody2D

var speed = 0
var health = 500

@onready var player = get_parent().get_node("Player")
@onready var shootTimer = get_node("ShootTimer")
@onready var healthLabel = get_node("HealthLabel")

var shot_scene: PackedScene

func _ready():
	shot_scene = preload("res://src/world/objects/EvilShot.tscn");

func _process(delta):
	healthLabel.text = str(health)
	if global_position.x < -1000:
		queue_free()

func _physics_process(delta):
	if health <= 0:
		die()
	speed = -0.02 * Global.speed;
	move_and_collide(Vector2(speed, 0))

func deal_damage(damage):
	health -= damage;

func die():
	queue_free();

func kill_player():
	player.die();

func _on_player_killer_body_entered(body):
	if (body.get_groups().has("player")):
		kill_player();

func _on_shoot_timer_timeout():
	if (global_position.x < 800):
		var direction = (player.global_position - global_position).normalized()
		var projectile_instance = shot_scene.instantiate()
		projectile_instance.global_position = global_position
		projectile_instance.velocity = direction * projectile_instance.speed
		get_parent().add_child(projectile_instance)