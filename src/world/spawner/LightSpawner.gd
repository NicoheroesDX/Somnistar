extends AnimatableBody2D

var tiny_light_scene: PackedScene
var small_light_scene: PackedScene
var medium_light_scene: PackedScene
var large_light_scene: PackedScene

func _ready():
	tiny_light_scene = preload("res://src/world/objects/lights/TinyLight.tscn");
	small_light_scene = preload("res://src/world/objects/lights/SmallLight.tscn");
	medium_light_scene = preload("res://src/world/objects/lights/MediumLight.tscn");
	large_light_scene = preload("res://src/world/objects/lights/LargeLight.tscn");

func _physics_process(delta):
	var speed = -0.03 * Global.speed;
	move_and_collide(Vector2(speed, 0));

func spawn_and_reset():
	var randomPosition = spawn_light();
	reset_position(randomPosition);

func spawn_light():
	var randomValue = randf()
	
	var light;
	var minRange;
	var maxRange;
	
	if Global.collectedLight <= 0:
		light = medium_light_scene.instantiate();
		minRange = 1000
		maxRange = 1500
	else:
		if randomValue < 0.10:
			light = large_light_scene.instantiate();
			minRange = 1500
			maxRange = 2000
		elif randomValue < 0.30:
			light = medium_light_scene.instantiate();
			minRange = 1000
			maxRange = 1500
		elif randomValue < 0.60:
			light = small_light_scene.instantiate();
			minRange = 900
			maxRange = 1200
		else:
			light = tiny_light_scene.instantiate();
			minRange = 800
			maxRange = 850
		
	var randomVector = Vector2(randf_range(minRange, maxRange), randf_range(-200, 0));
	light.global_position = randomVector;
	get_parent().get_parent().add_child(light);
	return randomVector;

func reset_position(newPosition):
	global_position = newPosition;
