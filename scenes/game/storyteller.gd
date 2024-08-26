class_name StoryTeller
extends Node

const level1 = preload("res://scenes/levels/level1/level1.tscn")
const level2 = preload("res://scenes/levels/level2/level2.tscn")
const level3 = preload("res://scenes/levels/level3/level3.tscn")
const credits = preload("res://scenes/credits/credits.tscn")

# tuples [time, callback]
var events_today := []

@export
var scene_parent: Node2D

@export
var season_icons: Array[CanvasItem] = []

@export
var time: GameTime
@export
var conversation_agent: ConversationAgent

@export
var ambience: AudioStreamPlayer
@export
var sleep_jingle: AudioStreamPlayer

@export
var sky: GameSky

@export
var end_day_ui: Control

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
	
	sky.day_start_h = 7
	sky.day_duration_h = 14
		
	if day == 0:
		var level: Level1 = change_level(level1.instantiate())
		
		events_today = [
			[8.0, level.think.bind("hello_world")],
			[10.0, level.dismiss_think],
			[10.0, level.enter_bug.bind("hopper_plant_1")],
			[11.0, level.exit_bug],
			[12.5, level.enter_moth_top.bind("moth_plant_1")],
			[13.5, level.exit_moth_bottom],
			[16.0, level.enter_moth_bottom.bind("moth_plant_2")],
			[17.0, level.exit_moth_top],
			[20.5, end_day],
		]
	elif day == 1:
		var level: Level2 = change_level(level2.instantiate())
		
		events_today = [
			[8.5, level.think.bind("think_morning")],
			[10.0, level.enter_snake.bind("snake_plant_1")],
			[12.5, level.exit_snake],
			[12.5, level.enter_ants.bind("ant1")],
			[13.0, level.dismiss_ants],
			[13.0, level.enter_ants.bind("ant7")],
			[13.5, level.dismiss_ants],
			[13.5, level.enter_ants.bind("ant2")],
			[14.0, level.dismiss_ants],
			[14.0, level.enter_bug.bind("hopper_plant_1")],
			[15.0, level.exit_bug],
			[15.5, level.enter_snake.bind("snake_plant_2")],
			[16.0, level.enter_berry],
			[16.5, level.exit_snake],
			[16.5, level.enter_ants.bind("ant3")],
			[17.0, level.dismiss_ants],
			[17.0, level.bird_pick_berry],
			[18.0, level.enter_ants.bind("ant4")],
			[18.5, level.dismiss_ants],
			[18.5, level.enter_ants.bind("ant5")],
			[19.0, level.dismiss_ants],
			[19.5, level.enter_ants.bind("ant6")],
			[20.0, level.dismiss_ants],
			[20.5, end_day],
		]
	elif day == 2:
		var level: Level3 = change_level(level3.instantiate())
		
		events_today = [
			[9.5, level.think.bind("think_morning")],
			[10, level.dismiss_think],
			[10.5, func(): get_tree().change_scene_to_packed(credits)],
			#[10, level.zoom_out],
			[20.5, end_day],
		]
	else:
		assert(false)
	
	time.paused = false

func end_day():
	time.paused = true
	end_day_ui.visible = true

func end_night():
	var next_day := current_day + 1
	
	end_day_ui.visible = false
	
	var tween := create_tween().set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property(time, "current_time_h", 21, 2).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): sleep_jingle.play()).set_delay(1.2)
	tween.set_parallel(false)
	tween.tween_property(time, "current_time_h", 24, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func(): start_day(next_day))
	tween.tween_property(time, "current_time_h", 7, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(time, "current_time_h", 7.5, 2).set_ease(Tween.EASE_OUT)
	tween.play()

func change_level(level: Node2D):	
	for prev_scene in scene_parent.get_children():
		prev_scene.queue_free()
	
	level.conversation_agent = conversation_agent
	scene_parent.add_child(level)
	
	return level

func _process(delta: float) -> void:
	while events_today.size() > 0 and time.current_time_h > events_today[0][0]:
		events_today[0][1].call()
		events_today.pop_front()

func _on_end_night_button_pressed():
	end_night()
