class_name StoryTeller
extends Node

# tuples [time, callback]
var events_today = []

@export
var season_icons: Array[CanvasItem] = []

@onready
var time: GameTime = %Time
@onready
var conversation_agent: ConversationAgent = %ConversationAgent
@export
var current_day := 0
var current_year := 0
var current_season := 0

func _ready():
	var tween = create_tween()
	tween.tween_callback(start).set_delay(0.1)
	tween.play()

func start():
	start_day(current_day)
	time.previous_time_h = 7.5
	time.current_time_h = 7.5

func start_day(day: int):
	time.current_time_h = 0
	
	current_day = day
	current_year = day / 4
	current_season = day % 4
	for i in season_icons.size():
		season_icons[i].visible = current_season == i
	
	time.seconds_per_hour = 1.0 / 14 * 60
	
	var sky := %Sky as GameSky
	sky.day_start_h = 7
	sky.day_duration_h = 14
	
	var _level := get_node_or_null("%Level")
	
	if day == 0:
		if not _level or _level is not Level1:
			_level = change_level(load("res://scenes/levels/level1.tscn").instantiate())

		var level := _level as Level1
		level.conversation_agent = conversation_agent
		
		events_today = [
			[8.5, level.offer_test_dialogue],
			[10.0, level.dismiss_test_dialogue],
			[20.5, end_day],
		]
	elif day == 1:
		if not _level or _level is not Level2:
			_level = change_level(load("res://scenes/levels/level2.tscn").instantiate())
		
		var level := _level as Level2
		level.conversation_agent = conversation_agent

		events_today = [
			[8, level.offer_test_dialogue],
			[12.5, level.dismiss_test_dialogue],
			[20.5, end_day],
		]
	elif day == 2:
		if not _level or _level is not Level1:
			_level = change_level(load("res://scenes/levels/level3.tscn").instantiate())
		
		var level := _level as Level3
		level.conversation_agent = conversation_agent

		events_today = [
			[8.5, level.offer_test_dialogue],
			[12, level.dismiss_test_dialogue],
			[20.5, end_day],
		]
	else:
		assert(false)
	
	time.paused = false

func end_day():
	if current_day == 2:
		get_tree().change_scene_to_file("res://scenes/credits.tscn")

	time.paused = true
	var end_day_ui := get_node("%EndDayUI") as Control
		
	(end_day_ui.get_node("Button") as Button).pressed.connect(end_night)
	end_day_ui.visible = true

func end_night():
	var end_day_ui := get_node("%EndDayUI") as Control
	var next_day := current_day + 1
	
	end_day_ui.visible = false
	
	var tween := create_tween().set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property(time, "current_time_h", 21, 2).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): (%SleepJingle as AudioStreamPlayer).play()).set_delay(1.2)
	tween.set_parallel(false)
	tween.tween_property(time, "current_time_h", 24, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func(): start_day(next_day))
	tween.tween_property(time, "current_time_h", 7, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(time, "current_time_h", 7.5, 2).set_ease(Tween.EASE_OUT)
	tween.play()

func change_level(level: Node2D):
	var game := get_node("..") as Node2D
	
	var prev_level := get_node_or_null("%Level")
	if prev_level:
		prev_level.unique_name_in_owner = false
		prev_level.name = "PrevLevel"
		prev_level.queue_free()
	
	level.name = "Level"
	game.add_child(level)
	game.move_child(level, 1)
	level.owner = game
	level.unique_name_in_owner = true
	
	return level

func _process(delta: float) -> void:
	while events_today.size() > 0 and time.current_time_h > events_today[0][0]:
		events_today[0][1].call()
		events_today.pop_front()
