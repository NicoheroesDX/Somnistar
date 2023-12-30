extends Node2D

@onready var optionsMenu = get_node("OptionsMenu")
@onready var creditsMenu = get_node("CreditsMenu")

@onready var highscoreMenu = get_node("HighscoreMenu")
@onready var highscoreLabel = get_node("HighscoreMenu/Highscore")
@onready var highscoreDateLabel = get_node("HighscoreMenu/HighscoreDate")

@onready var lastPlayedMenu = get_node("LastPlayedMenu")
@onready var lastScoreLabel = get_node("LastPlayedMenu/LastScore")
@onready var lastDateLabel = get_node("LastPlayedMenu/LastDate")

@onready var sfxSlider: HSlider = get_node("OptionsMenu/SFXSlider")
@onready var musicSlider: HSlider = get_node("OptionsMenu/MusicSlider")

@onready var screenSizeButtons: Array[Button] = [
	get_node("OptionsMenu/Screen1Rect/Screen1Button"),
	get_node("OptionsMenu/Screen2Rect/Screen2Button"),
	get_node("OptionsMenu/Screen3Rect/Screen3Button"),
	get_node("OptionsMenu/Screen4Rect/Screen4Button")
]

var music_audio_bus: int = AudioServer.get_bus_index("MusicBus")
var sfx_audio_bus: int = AudioServer.get_bus_index("SFXBus")

func _ready():
	hide_options_menu()
	hide_credits_menu()
	
	var current_music_volume = AudioServer.get_bus_volume_db(music_audio_bus)
	var current_sfx_volume = AudioServer.get_bus_volume_db(sfx_audio_bus)
	
	if Global.highscore != null && Global.highscoreDate != null && Global.lastScore != null && Global.lastScoreDate != null:
		highscoreLabel.text = Global.calculate_distance_str(Global.highscore);
		highscoreDateLabel.text = Global.calculate_date_str(Global.highscoreDate)
		lastScoreLabel.text = Global.calculate_distance_str(Global.lastScore);
		lastDateLabel.text = Global.calculate_date_str(Global.lastScoreDate)
	
	if Global.highscore <= 0:
		highscoreMenu.visible = false;
	else:
		highscoreMenu.visible = true;
	
	if Global.lastScore <= 0:
		lastPlayedMenu.visible = false;
	else:
		lastPlayedMenu.visible = true;
	
	if not load_options_from_file():
		print("Unable to load from file!")
		musicSlider.value = current_music_volume;
		sfxSlider.value = current_sfx_volume;
		screenSizeButtons[0].set_pressed(true);

func show_options_menu():
	optionsMenu.visible = true
	optionsMenu.mouse_filter = Control.MOUSE_FILTER_PASS
	
func hide_options_menu(saveChanges: bool = false):
	if (saveChanges):
		save_all_options()
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
	Global.change_scene_with_transition("res://src/world/World.tscn")

func _on_options_button_pressed():
	show_options_menu()
	
func _on_credits_button_pressed():
	show_credits_menu()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_close_button_pressed():
	hide_options_menu(true)

func _on_close_credits_button_pressed():
	hide_credits_menu()

func mute_if_needed(busIndex: int):
	var value = AudioServer.get_bus_volume_db(busIndex)
	if (value <= -30):
		AudioServer.set_bus_mute(busIndex, true)
	else:
		AudioServer.set_bus_mute(busIndex, false)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_audio_bus, value)
	mute_if_needed(sfx_audio_bus)

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_audio_bus, value)
	mute_if_needed(music_audio_bus)

func untoggle_all_buttons_except(exceptButtonIndex: int):
	for i in screenSizeButtons.size():
		if not i == exceptButtonIndex:
			screenSizeButtons[i].set_pressed(false);

func change_screen_size(factor: float):
	get_window().size = (Global.BASE_WINDOW_SIZE) * factor
	get_tree().root.content_scale_factor = factor

func _on_screen_1_button_toggled(toggled_on):
	if toggled_on:
		untoggle_all_buttons_except(0);
		change_screen_size(1);

func _on_screen_2_button_toggled(toggled_on):
	if toggled_on:
		untoggle_all_buttons_except(1);
		change_screen_size(1.5);

func _on_screen_3_button_toggled(toggled_on):
	if toggled_on:
		untoggle_all_buttons_except(2);
		change_screen_size(2);

func _on_screen_4_button_toggled(toggled_on):
	if toggled_on:
		untoggle_all_buttons_except(3);
		change_screen_size(2.5);

func get_toggeled_button():
	for i in screenSizeButtons.size():
		if screenSizeButtons[i].is_pressed(): 
			return i
	return -1;

func save_all_options():
	var config = ConfigFile.new()
	
	var toggeledButton = get_toggeled_button();
	if toggeledButton < 0 || toggeledButton >= screenSizeButtons.size(): 
		toggeledButton = 0;
	
	config.set_value("SFX", "volume", sfxSlider.value)
	config.set_value("Music", "volume", musicSlider.value)
	config.set_value("Screen", "size", toggeledButton)
	
	config.save(Global.CONFIG_FILE_LOCATION)
	print("Successfully saved to file!")

func load_options_from_file():
	var config = ConfigFile.new()
	
	if config.load(Global.CONFIG_FILE_LOCATION) == OK:
		var sfxVolume = config.get_value("SFX", "volume")
		var musicVolume = config.get_value("Music", "volume")
		var screenSize = config.get_value("Screen", "size")
		
		sfxSlider.value = sfxVolume
		musicSlider.value = musicVolume
		screenSizeButtons[screenSize].set_pressed(true)
		
		print("Successfully loaded from file!")
		
		return true;
	else:
		return false;
