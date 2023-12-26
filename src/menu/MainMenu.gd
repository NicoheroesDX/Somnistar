extends Node2D

@onready var optionsMenu = get_node("OptionsMenu")
@onready var creditsMenu = get_node("CreditsMenu")

func _ready():
	hide_options_menu()
	hide_credits_menu()

func show_options_menu():
	optionsMenu.visible = true
	optionsMenu.mouse_filter = Control.MOUSE_FILTER_PASS
	
func hide_options_menu():
	optionsMenu.visible = false
	optionsMenu.mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_credits_menu():
	creditsMenu.visible = true
	creditsMenu.mouse_filter = Control.MOUSE_FILTER_PASS
	
func hide_credits_menu():
	creditsMenu.visible = false
	creditsMenu.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_play_button_pressed():
	Global.reset_game_data();
	Global.change_scene("res://src/world/World.tscn")

func _on_options_button_pressed():
	show_options_menu()
	
func _on_credits_button_pressed():
	show_credits_menu()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_close_button_pressed():
	hide_options_menu()

func _on_close_credits_button_pressed():
	hide_credits_menu()
