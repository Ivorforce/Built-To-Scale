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
	print(day)
	
	time.previous_time_h = 7.5
	time.current_time_h = 7.5
	time.seconds_per_hour = 1.0 / 14 * 120
	if day == 0:
		time.seconds_per_hour /= 20
	
	var sky := %Sky as GameSky
	sky.day_start_h = 7
	sky.day_duration_h = 14
	
	events_today = [
		[8.5, func(): offer_conversation(get_node("%Level/%Mothertree/Button"), load("res://texts/test.dialogue"), "start")],
		[9, func(): dismiss_conversation(get_node("%Level/%Mothertree/Button"))],
		[20.5, end_day],
	]
	
	time.paused = false

func end_day():
	time.paused = true
	var end_day_ui := get_node("%EndDayUI") as Control
	
	(end_day_ui.get_node("Button") as Button).pressed.connect(end_night)
	end_day_ui.visible = true

func end_night():
	var end_day_ui := get_node("%EndDayUI") as Control
	
	end_day_ui.visible = false
	
	var tween := create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(time, "current_time_h", 21, 2).set_ease(Tween.EASE_IN)
	tween.tween_property(time, "current_time_h", 24+7, 2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(time, "current_time_h", 24+7.5, 2).set_ease(Tween.EASE_OUT)
	tween.play()
	await tween.finished
	start_day(current_day + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while events_today.size() > 0 and time.current_time_h > events_today[0][0]:
		events_today[0][1].call()
		events_today.pop_front()

func offer_conversation(button: Button, dialogue: DialogueResource, start_line_id: String):
	button.pressed.connect(func(): start_conversation(button, dialogue, start_line_id))
	button.visible = true

func start_conversation(button: Button, dialogue: DialogueResource, start_line_id: String):
	if conversation_agent.current_dialogue:
		return
	
	button.visible = false
	conversation_agent.start_conversation(dialogue, start_line_id)

func dismiss_conversation(button: Button):
	button.visible = false
