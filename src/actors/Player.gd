extends CharacterBody2D

const SPEED = 30.0
const SPEED_LIMIT = 300.0
const AIR_RESISTANCE = 10.0;

@onready var stompCooldown = get_node("StompCooldown")
@onready var glider = get_node("GlideParticles")
@onready var stompParticles = get_node("StompParticles")

@onready var beam = get_node("PlayerAttack/BeamParticles")
@onready var beamCore = get_node("PlayerAttack/CoreParticles")
@onready var beamHitbox = get_node("PlayerAttack/BeamArea")

@onready var stompSound = get_node("StompSound")
@onready var glideSound = get_node("GlideSound")
@onready var glideStopSound = get_node("GlideStopSound")

@onready var beamSound = get_node("PlayerAttack/BeamSound")
@onready var beamFade = get_node("PlayerAttack/BeamFadeout")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var isPlayingBeamSound = false;

var glideLength = 0

func _physics_process(delta):
	# Check if player is out of bounds
	if global_position.y > 800:
		die();
	
	Global.update_speed((700 + global_position.x) * 0.1)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x += direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var hasBeamedLastFrame = false;
	
	if beam.is_emitting():
		hasBeamedLastFrame = true;
	
	beam.emitting = Global.collectedLight > 0 && Input.is_action_pressed("player_shoot")
	
	beamCore.emitting = beam.emitting
	
	if (hasBeamedLastFrame && not beam.emitting):
		beamFade.play();
	
	if beam.emitting:
		Global.change_collected_light(-24);
		velocity.x -= 150
		if not isPlayingBeamSound:
			beamSound.play()
			isPlayingBeamSound = true
		for body in beamHitbox.get_overlapping_bodies():
			if (body.get_groups().has("enemy")):
				body.deal_damage(15);
	else:
		beamSound.stop();
		isPlayingBeamSound = false;
	
	velocity.x -= AIR_RESISTANCE;
	
	if velocity.x > 0:
		velocity.x = min(SPEED_LIMIT, velocity.x)
	elif velocity.x < 0:
		velocity.x = max(-SPEED_LIMIT, velocity.x)
	
	if stompCooldown.time_left == 0 && Global.collectedLight > 0 && Input.is_action_just_pressed("player_down"):
		velocity.y = 1000;
		Global.change_collected_light(-8);
		stompSound.play();
		stompCooldown.wait_time = 0.2;
		stompCooldown.start();
	
	if Global.collectedLight > 0 && Input.is_action_pressed("player_up"):
		velocity.y = 10;
		if not glider.emitting:
			glideSound.play();
		glider.emitting = true;
		glideLength += 1;
		Global.change_collected_light(-16);
	else:
		if glideLength > 25 && glider.emitting:
			glideStopSound.play();
		glider.emitting = false;
		glideLength = 0
	
	if velocity.y > 600:
		stompParticles.emitting = true
	else:
		stompParticles.emitting = false
	
	move_and_slide()

func die():
	global_position.y = -300
	velocity = Vector2(0,0)
	Global.change_scene("res://src/menu/GameOver.tscn")
