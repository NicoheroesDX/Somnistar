extends Node2D

func _ready():
	Global.update_scores();

func _on_button_pressed():
	Global.reset_game_data();
	Global.change_scene_with_transition("res://src/world/World.tscn")

func _on_menu_button_pressed():
	Global.reset_game_data();
	Global.change_scene_with_transition("res://src/menu/MainMenu.tscn")
