extends AnimatableBody2D

var speed = 0
var maxHealth = 0
var health = 0

@onready var player = get_parent().get_node("Player")
@onready var shootTimer = get_node("ShootTimer")
@onready var chargeTimer = get_node("ChargeTimer")
@onready var healthBarBorder = get_node("ColorRect")
@onready var healthBar: ProgressBar = get_node("ColorRect/ProgressBar")

@onready var hurtSoundCooldown = get_node("HurtSoundCooldown")

@onready var shootSound = get_node("ShootSound")
@onready var chargeSound = get_node("ChargeSound")
@onready var hurtSound = get_node("HurtSound")
@onready var deathSound = get_node("DeathSound")

@onready var timer = get_node("DespawnTimer")
@onready var animation = get_node("AnimationPlayer")

var shot_scene: PackedScene

var isDead = false

func _ready():
	shot_scene = preload("res://src/world/objects/EvilShot.tscn");
	if Global.distance > 20000:
		maxHealth = randi_range(800, 1000)
	elif Global.distance > 15000:
		maxHealth = randi_range(700, 900)
	elif Global.distance > 10000:
		maxHealth = randi_range(600, 800)
	elif Global.distance > 5000:
		maxHealth = randi_range(500, 700)
	else:
		maxHealth = randi_range(400, 600)
	
	healthBar.max_value = maxHealth
	health = maxHealth

func _process(delta):
	if not isDead:
		healthBar.value = health
	if isDead || health == maxHealth:
		healthBar.visible = false
		healthBarBorder.visible = false
	else:
		healthBar.visible = true
		healthBarBorder.visible = true
	if global_position.x < -1000:
		if not isDead:
			Global.skippedEnemys += 1;
		queue_free()

func _physics_process(delta):
	if not isDead:
		if health <= 0:
			die()
	speed = -0.02 * Global.speed;
	move_and_collide(Vector2(speed, 0))

func deal_damage(damage):
	if not isDead && global_position.x < 750:
		if hurtSoundCooldown.time_left <= 0:
			hurtSound.pitch_scale = randf_range(0.6, 1.4)
			hurtSound.play();
			hurtSoundCooldown.start();
		health -= damage;

func die():
	if not isDead:
		isDead = true
		deathSound.play();
		animation.play("death");
		timer.start();

func kill_player():
	if not isDead:
		player.die();

func _on_player_killer_body_entered(body):
	if not isDead:
		if (body.get_groups().has("player")):
			kill_player();

func _on_shoot_timer_timeout():
	if not isDead:
		if (global_position.x < 800):
			chargeSound.play()
			chargeTimer.start()

func _on_charge_timer_timeout():
	if not isDead:
		shootSound.play()
		var direction = (player.global_position - global_position).normalized()
		var projectile_instance = shot_scene.instantiate()
		projectile_instance.global_position = global_position
		projectile_instance.velocity = direction * projectile_instance.speed
		get_parent().add_child(projectile_instance)

func _on_despawn_timer_timeout():
	queue_free()
