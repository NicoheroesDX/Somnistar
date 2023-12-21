extends Node2D

@onready var player: CharacterBody2D = get_node("Player")

var cloud_scene: PackedScene

var cloud_interval : float = 200.0
var last_cloud_spawned_at : float = 0.0

func _ready():
	cloud_scene = preload("res://src/world/objects/Cloud.tscn")

func _process(delta):
	if player.global_position.x - last_cloud_spawned_at > cloud_interval:
		spawn_cloud();
		last_cloud_spawned_at = player.global_position.x
	
	if player.global_position.y > 400:
		player.global_position.y = 0
		player.velocity = Vector2(0,0)

func spawn_cloud():
	var cloud = cloud_scene.instantiate();
	
	cloud.global_position = Vector2(player.global_position.x + 800, randf_range(0, 200))
	
	add_child(cloud);
