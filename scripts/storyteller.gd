class_name StoryTeller
extends Node

var planned_interaction_times = []
var planned_interaction_callbacks = []

@onready
var time: GameTime = %Time

func _ready() -> void:
	plan_interactions(0)

func conv_mother_tree():
	(%Mothertree.get_node("Button") as ConversationButton).offer_conversation(
		load("res://texts/test.dialogue"), "start"
	)
	
func conv_mother_tree_stop():
	(%Mothertree.get_node("Button") as ConversationButton).dismiss_conversation()

func plan_interactions(day: int):
	planned_interaction_times = [8.5, 9]
	planned_interaction_callbacks = [conv_mother_tree, conv_mother_tree_stop]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while planned_interaction_times.size() > 0 and time.current_time_h > planned_interaction_times[0]:
		planned_interaction_callbacks[0].call()
		planned_interaction_callbacks.pop_front()
		planned_interaction_times.pop_front()
