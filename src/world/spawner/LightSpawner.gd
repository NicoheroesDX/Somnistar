extends AnimatableBody2D

var light_scene: PackedScene

func _ready():
	light_scene = preload("res://src/world/objects/Light.tscn");

func _physics_process(delta):
	var speed = -0.03 * Global.speed;
	move_and_collide(Vector2(speed, 0));

func spawn_and_reset():
	var randomPosition = spawn_light();
	reset_position(randomPosition);

func spawn_light():
	var light = light_scene.instantiate();
	var randomVector = Vector2(randf_range(1000, 2000), randf_range(-200, 0));
	light.global_position = randomVector;
	get_parent().get_parent().add_child(light);
	return randomVector;

func reset_position(newPosition):
	global_position = newPosition;
