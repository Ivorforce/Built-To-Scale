class_name StoryTeller
extends Node

# tuples [time, callback]
var events_today = []

@onready
var time: GameTime = %Time

func _ready() -> void:
	plan_events(0)

func conv_mother_tree():
	(%Mothertree.get_node("Button") as ConversationButton).offer_conversation(
		load("res://texts/test.dialogue"), "start"
	)
	
func conv_mother_tree_stop():
	(%Mothertree.get_node("Button") as ConversationButton).dismiss_conversation()

func plan_events(day: int):
	events_today = [
		[8.5, conv_mother_tree],
		[9, conv_mother_tree_stop],
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while events_today.size() > 0 and time.current_time_h > events_today[0][0]:
		events_today[0][1].call()
		events_today.pop_front()
