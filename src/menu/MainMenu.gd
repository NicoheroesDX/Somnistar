extends Node2D

@onready var playButton = get_node("PlayRect/PlayButton")
@onready var extrasButton = get_node("ExtrasRect/ExtrasButton")
@onready var optionsButton = get_node("OptionsRect/OptionsButton")
@onready var creditsButton = get_node("CreditsRect/CreditsButton")
@onready var exitButton = get_node("ExitRect/ExitButton")

@onready var extrasMenu = get_node("ExtrasMenu")
@onready var optionsMenu = get_node("OptionsMenu")
@onready var creditsMenu = get_node("CreditsMenu")

@onready var closeExtrasButton = get_node("ExtrasMenu/CloseRect/CloseExtrasButton")
@onready var closeOptionsButton = get_node("OptionsMenu/CloseRect/CloseButton")
@onready var closeCreditsButton = get_node("CreditsMenu/CloseRect/CloseCreditsButton")

@onready var highscoreMenu = get_node("HighscoreMenu")
@onready var highscoreLabel = get_node("HighscoreMenu/Highscore")
@onready var highscoreDateLabel = get_node("HighscoreMenu/HighscoreDate")

@onready var lastPlayedMenu = get_node("LastPlayedMenu")
@onready var lastScoreLabel = get_node("LastPlayedMenu/LastScore")
@onready var lastDateLabel = get_node("LastPlayedMenu/LastDate")

@onready var sfxSlider: HSlider = get_node("OptionsMenu/SFXSlider")
@onready var musicSlider: HSlider = get_node("OptionsMenu/MusicSlider")

@onready var extrasPageNumber: Label = get_node("ExtrasMenu/PageLabel")
@onready var extrasPageTitle: Label = get_node("ExtrasMenu/PageName")
@onready var extrasPageContent: Label = get_node("ExtrasMenu/ContentRect/ScrollContainer/PageContent")

@onready var screenSizeButtons: Array[Button] = [
	get_node("OptionsMenu/Screen1Rect/Screen1Button"),
	get_node("OptionsMenu/Screen2Rect/Screen2Button"),
	get_node("OptionsMenu/Screen3Rect/Screen3Button"),
	get_node("OptionsMenu/Screen4Rect/Screen4Button")
]

var extraPages: Array[Page] = [
	Page.new("Story", 
	"""	Introducing Somnistar, the 5th Stella Guardian, devoted to protecting dreams and ensuring 
	everyone sleeps peacefully.
	
	Her mission?
	To stop "The Wall" from getting bigger. No one knows what "The Wall" is or where it comes from, 
	but it causes nightmares across the universe and is fueled by a species known as Invebula.
	Invebula can be identified by their red aura and an appearance resembling an inverse-cloud.
	
	Every time "The Wall" absorbs an Invebula, it grows faster, making it crucial to eliminate them.
	Somnistar wields lumen-based magic, a special power only available to those with pure hearts.
	
	As Somnistar gathers Lumen along her journey, she becomes stronger, gaining new abilities like 
	stomping, gliding, and beaming."""),
	Page.new("Controls", 
	"""	A or D / ArrowLeft or ArrowRight
	Move Somnistar left or right.
	
	S / ArrowDown (Press)
	Utilize the stomp ability to descend rapidly, evading enemy projectiles or reaching clouds at the 
	bottom of the screen with greater ease. 
	Keep in mind that each stomp consumes a portion of your Lumen.
	
	W / ArrowUp (Press / Hold)
	Use the glide ability to slow your descent and boost your aerial momentum. 
	It can be used to negate a cloud's bounce effect and halting your stomp instantly. 
	Be cautious, as activating this ability will entirely obliterate a cloud without triggering an 
	upward bounce upon contact. 
	Keep in mind that utilizing this power comes at the cost of a significant drain on your Lumen.
	
	Space / Enter (Hold)
	Deploy the beam ability to eliminate the Invebula. Be mindful, as the force of the beam will also 
	result in a slight backward push. 
	Keep in mind that utilizing this power comes at the expense of a notable drain on your Lumen."""),
	Page.new("Tips", 
	"""	Somnistar can meet her demise by falling into the abyss, making contact with an enemy or 
	its projectile, or getting soaked into "The Wall" when having no Lumen energy.
	
	Clouds act as springboards, propelling Somnistar upwards upon contact.
	
	Lumen comes in four different sizes, increasing your Lumen-Meter upon collection. 
	This not only grants Somnistar new abilities but also shields her from the power of "The Wall."
	
	If an Invebula gets absorbed by "The Wall" it will make it faster. Therefore all of them should 
	be eliminated immediately. If "The Wall" absorbs too many enemies, 
	it could get impossible to outrun it.
	
	As you go farther, Somnistar and "The Wall" will speed up, and the Invebula will become tougher. 
	After 30 km the maximum difficulty of the game is reached."""),
]

var currentExtrasPage = 0

var music_audio_bus: int = AudioServer.get_bus_index("MusicBus")
var sfx_audio_bus: int = AudioServer.get_bus_index("SFXBus")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	hide_options_menu()
	hide_credits_menu()
	
	refresh_extras_page()
	
	playButton.grab_focus()
	
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
		musicSlider.value = current_music_volume;
		sfxSlider.value = current_sfx_volume;
		screenSizeButtons[0].set_pressed(true);

func show_extras_menu():
	extrasMenu.visible = true
	extrasMenu.mouse_filter = Control.MOUSE_FILTER_PASS
	
func hide_extras_menu():
	extrasMenu.visible = false
	extrasMenu.mouse_filter = Control.MOUSE_FILTER_IGNORE

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

func _on_extras_button_pressed():
	show_extras_menu()
	closeExtrasButton.grab_focus()

func _on_options_button_pressed():
	show_options_menu()
	closeOptionsButton.grab_focus()
	
func _on_credits_button_pressed():
	show_credits_menu()
	closeCreditsButton.grab_focus()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_close_extras_button_pressed():
	hide_extras_menu()
	extrasButton.grab_focus()
	
func _on_close_button_pressed():
	hide_options_menu(true)
	optionsButton.grab_focus()

func _on_close_credits_button_pressed():
	hide_credits_menu()
	creditsButton.grab_focus()

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
	var newWindowSize = (Global.BASE_WINDOW_SIZE) * factor
	get_window().size = newWindowSize
	get_tree().root.content_scale_factor = factor
	get_window().position = Vector2i((DisplayServer.screen_get_size().x - newWindowSize.x) / 2, 30) 

func _on_screen_1_button_toggled(toggled_on):
	if toggled_on:
		untoggle_all_buttons_except(0);
		change_screen_size(1);
	elif get_toggeled_button() == -1:
		screenSizeButtons[0].set_pressed(true);

func _on_screen_2_button_toggled(toggled_on):
	if toggled_on:
		untoggle_all_buttons_except(1);
		change_screen_size(1.5);
	elif get_toggeled_button() == -1:
		screenSizeButtons[1].set_pressed(true);

func _on_screen_3_button_toggled(toggled_on):
	if toggled_on:
		untoggle_all_buttons_except(2);
		change_screen_size(2);
	elif get_toggeled_button() == -1:
		screenSizeButtons[2].set_pressed(true);

func _on_screen_4_button_toggled(toggled_on):
	if toggled_on:
		untoggle_all_buttons_except(3);
		change_screen_size(2.5);
	elif get_toggeled_button() == -1:
		screenSizeButtons[3].set_pressed(true);

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

func load_options_from_file():
	var config = ConfigFile.new()
	
	if config.load(Global.CONFIG_FILE_LOCATION) == OK:
		var sfxVolume = config.get_value("SFX", "volume")
		var musicVolume = config.get_value("Music", "volume")
		var screenSize = config.get_value("Screen", "size")
		
		sfxSlider.value = sfxVolume
		musicSlider.value = musicVolume
		screenSizeButtons[screenSize].set_pressed(true)
		
		return true;
	else:
		return false;

func refresh_extras_page():
	extrasPageNumber.text = "Page " + str(currentExtrasPage + 1) + "/" + str(extraPages.size())
	extrasPageTitle.text = str(extraPages[currentExtrasPage].page)
	extrasPageContent.text = str(extraPages[currentExtrasPage].content)

func go_to_extras_page(index: int):
	if index < 0:
		currentExtrasPage = extraPages.size() - 1;
	elif index >= extraPages.size():
		currentExtrasPage = 0;
	else:
		currentExtrasPage = index;
	
	refresh_extras_page()

func _on_left_button_pressed():
	go_to_extras_page(currentExtrasPage - 1)

func _on_right_button_pressed():
	go_to_extras_page(currentExtrasPage + 1)
