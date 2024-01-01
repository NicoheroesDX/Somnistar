extends Node2D

@onready var player: CharacterBody2D = get_node("Player")

@onready var bgA: Sprite2D = get_node("BackgroundA");
@onready var bgB: Sprite2D = get_node("BackgroundB");

@onready var normalMusic: AudioStreamPlayer = get_node("NormalBackgroundMusic");
@onready var rareMusic: AudioStreamPlayer = get_node("RareBackgroundMusic");

@onready var lightBar = get_node("CanvasGroup/TopContainer/ProgressBar");
@onready var lightLabel = get_node("CanvasGroup/TopContainer/LumenNumber");

@onready var distanceLabel = get_node("CanvasGroup/BottomContainer/DistanceNumber");

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if (randi_range(1, 10) == 7):
		rareMusic.play()
	else:
		normalMusic.play()
	Global.update_collected_light_signal.connect(refresh_light_amount)
	Global.update_distance.connect(refresh_distance)
	refresh_light_amount(0, 0)
	refresh_distance(0)

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

func refresh_light_amount(newLightAmount, oldLightAmount):
	lightBar.value = newLightAmount;
	lightLabel.text = str(newLightAmount);

func refresh_distance(newDistance):
	distanceLabel.text = Global.calculate_distance_str(newDistance)
