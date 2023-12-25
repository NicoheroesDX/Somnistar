extends CharacterBody2D

const SPEED = 30.0
const SPEED_LIMIT = 300.0
const AIR_RESISTANCE = 10.0;

@onready var stompCooldown = get_node("StompCooldown")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	
	velocity.x -= AIR_RESISTANCE;
	
	if velocity.x > 0:
		velocity.x = min(SPEED_LIMIT, velocity.x)
	elif velocity.x < 0:
		velocity.x = max(-SPEED_LIMIT, velocity.x)
	
	if stompCooldown.time_left == 0 && Input.is_action_just_pressed("player_down"):
		velocity.y = 1000;
		stompCooldown.wait_time = 0.2;
		stompCooldown.start();
	
	move_and_slide()

func die():
	global_position.y = -300
	velocity = Vector2(0,0)
