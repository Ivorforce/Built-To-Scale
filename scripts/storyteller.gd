class_name StoryTeller
extends Node

# tuples [time, callback]
var events_today = []

@onready
var time: GameTime = %Time
@onready
var conversation_agent: ConversationAgent = %ConversationAgent
@export
var current_day := 0

func _ready():
	start_day(0)

func start_day(day: int):
	current_day = day
	
	time.previous_time_h = 7.5
	time.current_time_h = 7.5
	time.seconds_per_hour = 1.0 / 14 * 120
	
	var sky := %Sky as GameSky
	sky.day_start_h = 7
	sky.day_duration_h = 14
	
	if day == 0:
		var level := %Level as Level1
		
		events_today = [
			[8.5, level.offer_test_dialogue],
			[9, level.dismiss_test_dialogue],
			[20.5, end_day],
		]
	elif day == 1:
		var level := %Level as Level2
		
		events_today = [
			[8.5, level.offer_test_dialogue],
			[9, level.dismiss_test_dialogue],
			[20.5, end_day],
		]
	elif day == 2:
		var level := %Level as Level3
		
		events_today = [
			[8.5, level.offer_test_dialogue],
			[9, level.dismiss_test_dialogue],
			[20.5, end_day],
		]
	else:
		assert(false)
	
	time.paused = false

func end_day():
	time.paused = true
	var end_day_ui := get_node("%EndDayUI") as Control
	
	(end_day_ui.get_node("Button") as Button).pressed.connect(end_night)
	end_day_ui.visible = true

func end_night():
	var end_day_ui := get_node("%EndDayUI") as Control
	var next_day := current_day + 1
	
	end_day_ui.visible = false
	
	var tween := create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(time, "current_time_h", 21, 2).set_ease(Tween.EASE_IN)
	tween.tween_property(time, "current_time_h", 24, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func(): transition_to_day(next_day))
	tween.tween_property(time, "current_time_h", 7, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(time, "current_time_h", 7.5, 2).set_ease(Tween.EASE_OUT)
	tween.play()
	await tween.finished
	start_day(next_day)

func transition_to_day(day: int):
	time.current_time_h = 0
	
	if day == 0:
		if %Level is not Level1:
			change_level(load("res://scenes/levels/level1.tscn").instantiate())
	elif day == 1:
		if %Level is not Level2:
			change_level(load("res://scenes/levels/level2.tscn").instantiate())
	elif day == 2:
		if %Level is not Level3:
			change_level(load("res://scenes/levels/level3.tscn").instantiate())

func change_level(level: Node2D):
	var game := get_node("..") as Node2D
	var prev_level = %Level
	
	prev_level.unique_name_in_owner = false
	prev_level.name = "PrevLevel"
	prev_level.queue_free()
	
	level.name = "Level"
	game.add_child(level)
	game.move_child(level, 2)
	level.owner = game
	level.unique_name_in_owner = true

func _process(delta: float) -> void:
	while events_today.size() > 0 and time.current_time_h > events_today[0][0]:
		events_today[0][1].call()
		events_today.pop_front()
