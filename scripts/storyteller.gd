class_name StoryTeller
extends Node

# tuples [time, callback]
var events_today = []

@onready
var time: GameTime = %Time

func _ready() -> void:
	start_day(0)

func start_day(day: int):
	time.previous_time_h = 7.5
	time.current_time_h = 7.5
	time.seconds_per_hour = 1.0 / 14 * 120
	
	var sky := %Sky as GameSky
	sky.day_start_h = 7
	sky.day_duration_h = 14
	
	events_today = [
		[8.5, func(): offer_conversation(%Mothertree.get_node("Button"), load("res://texts/test.dialogue"), "start")],
		[9, func(): dismiss_conversation(%Mothertree.get_node("Button"))],
		[20.5, end_day],
	]
	
	time.paused = false

func end_day():
	time.paused = true
	(%EndDayUI.get_node("Button") as Button).pressed.connect(end_night)
	(%EndDayUI as Control).visible = true

func end_night():
	(%EndDayUI as Control).visible = false
	var tween := create_tween()
	tween.tween_property(%Time, "current_time_h", 24 + 8, 2)
	tween.play()
	await tween.finished
	time.paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while events_today.size() > 0 and time.current_time_h > events_today[0][0]:
		events_today[0][1].call()
		events_today.pop_front()

func offer_conversation(button: Button, dialogue: DialogueResource, start_line_id: String):
	button.pressed.connect(func(): start_conversation(button, dialogue, start_line_id))
	button.visible = true

func start_conversation(button: Button, dialogue: DialogueResource, start_line_id: String):
	var agent := %ConversationAgent as ConversationAgent
	if agent.current_dialogue:
		return
	
	button.visible = false
	agent.start_conversation(dialogue, start_line_id)

func dismiss_conversation(button: Button):
	button.visible = false
