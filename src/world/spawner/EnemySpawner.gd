extends AnimatableBody2D

var enemy_scene: PackedScene

func _ready():
	enemy_scene = preload("res://src/world/objects/Enemy.tscn");

func _physics_process(delta):
	var speed = -0.02 * Global.speed;
	move_and_collide(Vector2(speed, 0));

func spawn_and_reset():
	var randomPosition = spawn_enemy();
	reset_position(randomPosition);

func spawn_enemy():
	var enemy = enemy_scene.instantiate();
	var randomVector = Vector2(randf_range(1500, 4000), randf_range(-300, 50));
	enemy.global_position = randomVector;
	get_parent().get_parent().add_child(enemy);
	return randomVector;

func reset_position(newPosition):
	global_position = newPosition;
