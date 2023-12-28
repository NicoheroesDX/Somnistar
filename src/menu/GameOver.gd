extends Node2D

@onready var finalDistance = get_node("Canvas/FinalDistance")
@onready var finalLight = get_node("Canvas/FinalLight")

func _ready():
	finalDistance.text = Global.calculate_distance_str(Global.distance)
	finalLight.text = str(Global.collectedLight)

func _on_button_pressed():
	Global.reset_game_data();
	Global.change_scene_with_translation("res://src/world/World.tscn")

func _on_menu_button_pressed():
	Global.reset_game_data();
	Global.change_scene_with_translation("res://src/menu/MainMenu.tscn")
