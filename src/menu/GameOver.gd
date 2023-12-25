extends Node2D

@onready var finalDistance = get_node("Canvas/FinalDistance")
@onready var finalLight = get_node("Canvas/FinalLight")

func _ready():
	finalDistance.text = "0.000 m"
	finalLight.text = str(Global.collectedLight)

func _on_button_pressed():
	Global.reset_game_data();
	Global.change_scene("res://src/world/World.tscn")
