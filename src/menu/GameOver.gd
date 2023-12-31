extends Node2D

@onready var timeLabel = get_node("Canvas/UpperRect/TimeLabel")
@onready var scoreLabel = get_node("Canvas/UpperRect/ScoreLabel")
@onready var highscoreIndicator = get_node("Canvas/UpperRect/HighscoreIndicator")
@onready var lastHighscore = get_node("Canvas/UpperRect/LastHighscore")
@onready var highscoreLabel = get_node("Canvas/UpperRect/HighscoreLabel")
@onready var highscoreDate = get_node("Canvas/UpperRect/HighscoreDate")
@onready var collectedLumenLabel = get_node("Canvas/LowerRect/LumenLabel")
@onready var defeatedEnemiesLabel = get_node("Canvas/LowerRect/EnemyLabel")

@onready var mainMenuButton = get_node("MainMenuRect")
@onready var restartButton = get_node("RestartRect")
@onready var screenshotButton = get_node("ScreenshotRect")

@onready var screenshotSuccessful = get_node("ScreenshotSuccessful")

func _ready():
	timeLabel.text = Global.calculate_date_str(Time.get_datetime_string_from_system());
	scoreLabel.text = Global.calculate_distance_str(Global.distance);
	
	if Global.distance > Global.highscore:
		highscoreIndicator.visible = true;
	else:
		highscoreIndicator.visible = false;
		
	if Global.highscore <= 0:
		lastHighscore.visible = false;
		highscoreLabel.visible = false;
		highscoreDate.visible = false;
	else:
		lastHighscore.visible = true;
		highscoreLabel.visible = true;
		highscoreDate.visible = true;
		
	highscoreLabel.text = Global.calculate_distance_str(Global.highscore)
	highscoreDate.text = Global.calculate_date_str(Global.highscoreDate)
	
	collectedLumenLabel.text = str(Global.totalCollectedLight);
	defeatedEnemiesLabel.text = str(Global.killedEnemys);
	
	Global.update_scores();

func _on_menu_button_pressed():
	Global.reset_game_data();
	Global.change_scene_with_transition("res://src/menu/MainMenu.tscn")
	
func _on_restart_button_pressed():
	Global.reset_game_data();
	Global.change_scene_with_transition("res://src/world/World.tscn")

func _on_screenshot_button_pressed():
	mainMenuButton.visible = false
	restartButton.visible = false
	screenshotButton.visible = false
	
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("user://screenshot.png")
	
	mainMenuButton.visible = true
	restartButton.visible = true
	
	screenshotSuccessful.visible = true
	
	print("Saved")
