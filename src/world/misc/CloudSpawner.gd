extends AnimatableBody2D

var cloud_scene: PackedScene

func _ready():
	cloud_scene = preload("res://src/world/objects/Cloud.tscn");

func _physics_process(delta):
	var speed = -0.1 * Global.speed;
	print(global_position)
	move_and_collide(Vector2(speed, 0));

func spawn_and_reset():
	var randomPosition = spawn_cloud();
	reset_position(randomPosition);

func spawn_cloud():
	var cloud = cloud_scene.instantiate();
	var randomVector = Vector2(1000, randf_range(0, 200));
	cloud.global_position = randomVector;
	get_parent().get_parent().add_child(cloud);
	return randomVector;

func reset_position(newPosition):
	global_position = newPosition;
