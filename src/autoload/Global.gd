extends Node

const BASE_WINDOW_SIZE = Vector2i(1152, 648)

const USER_FOLDER = "user://"

const GAME_FOLDER = USER_FOLDER + "Somnistar"

const SAVES_FOLDER_LOCATION = GAME_FOLDER + "/data"
const SCREENSHOT_FOLDER_LOCATION = GAME_FOLDER + "/screenshots"

const CONFIG_FILE_LOCATION = SAVES_FOLDER_LOCATION + "/somnistar_options.cfg"
const HIGHSCORE_FILE_LOCATION = SAVES_FOLDER_LOCATION + "/somnistar.hisc"

var speed = 0
var distance = 0
var collectedLight = 0
var totalCollectedLight = 0

var skippedEnemys = 0
var killedEnemys = 0

var highscore;
var highscoreDate;

var lastScore;
var lastScoreDate;

signal update_collected_light_signal(new_light_amount, old_light_amount)
signal update_distance(new_distance)

signal transition_complete

const MONTHS: Array[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

func _ready():
	create_game_folder();
	get_highscore_from_file();
		
	if highscore == null:
		highscore = 0;
	if highscoreDate == null:
		highscoreDate = Time.get_datetime_string_from_system();
	if lastScore == null:
		lastScore = 0;
	if lastScoreDate == null:
		lastScoreDate = Time.get_datetime_string_from_system();

func create_game_folder():
	DirAccess.open(USER_FOLDER).make_dir_recursive(SAVES_FOLDER_LOCATION);
	DirAccess.open(USER_FOLDER).make_dir_recursive(SCREENSHOT_FOLDER_LOCATION);

func update_speed(newGlobalSpeed):
	speed = newGlobalSpeed;
	distance += 0.01 * speed;
	update_distance.emit(distance)

func change_collected_light(lightAmountOperation):
	var oldLightAmount = collectedLight
	var newLightAmount = collectedLight + lightAmountOperation
	
	if lightAmountOperation > 0:
		Global.totalCollectedLight += lightAmountOperation
	
	if newLightAmount < 0:
		newLightAmount = 0;
	elif newLightAmount > 20000:
		newLightAmount = 20000;
	collectedLight = newLightAmount;
	update_collected_light_signal.emit(newLightAmount, oldLightAmount)

func calculate_distance_str(newDistance):
	if newDistance > 10000:
		return str(snappedf((newDistance / 1000.0), 0.01)) + " km"
	else:
		return str(snappedf(newDistance, 1)) + " m"

func calculate_date_str(dateString):
	var dateTime = Time.get_datetime_dict_from_datetime_string(dateString, false)
	return str(dateTime.day).pad_zeros(2) + ". " + MONTHS[dateTime.month - 1] + " " + str(dateTime.year) + " - " + str(dateTime.hour).pad_zeros(2) + ":" + str(dateTime.minute).pad_zeros(2)

func reset_game_data():
	speed = 0
	distance = 0
	collectedLight = 0
	killedEnemys = 0
	totalCollectedLight = 0

func update_scores():
	if distance > highscore:
		highscore = distance;
		highscoreDate = Time.get_datetime_string_from_system();
	lastScore = distance;
	lastScoreDate = Time.get_datetime_string_from_system();
	save_highscore_to_file();

func save_highscore_to_file():
	var highscoreFile = ConfigFile.new()
	
	highscoreFile.set_value("Highscore", "value", highscore)
	highscoreFile.set_value("Highscore", "date", highscoreDate)
	highscoreFile.set_value("LastScore", "value", lastScore)
	highscoreFile.set_value("LastScore", "date", lastScoreDate)
	
	highscoreFile.save(Global.HIGHSCORE_FILE_LOCATION)

func get_highscore_from_file():
	var highscoreFile = ConfigFile.new()
	
	if highscoreFile.load(Global.HIGHSCORE_FILE_LOCATION) == OK:
		var score = highscoreFile.get_value("Highscore", "value")
		var date = highscoreFile.get_value("Highscore", "date")
		var lscore = highscoreFile.get_value("LastScore", "value")
		var ldate = highscoreFile.get_value("LastScore", "date")
		
		highscore = score
		highscoreDate = date
		
		lastScore = lscore
		lastScoreDate = ldate
		
		return true;
	else:
		return false

func change_scene_with_transition(pathToScene):
	var transitionLayer = get_tree().root.get_node("MainScene").get_node("TransitionLayer")
	if (transitionLayer != null):
		transitionLayer.start_transition_and_change_scene(pathToScene)
	else:
		change_scene(pathToScene)

func change_scene(pathToScene):
	var mainScene = get_tree().root.get_node("MainScene").get_node("MainDisplay")
	var transitionLayer = get_tree().root.get_node("MainScene").get_node("TransitionLayer")
	
	if (mainScene != null):
		var removable = mainScene.get_child(0)
		removable.queue_free()
		
		var scene_to_instantiate = load(pathToScene)
		var instantiated_scene = scene_to_instantiate.instantiate()
		
		mainScene.add_child(instantiated_scene)
