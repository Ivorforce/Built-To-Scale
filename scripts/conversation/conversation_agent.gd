extends Node

var current_dialogue: DialogueResource
var next_line: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_line(load("res://texts/test.dialogue"), "start")

func show_line(dialogue: DialogueResource, line_id: String):
	var conversation: ConversationBox = %ConversationBox
	
	if not line_id:
		conversation.set_line(null)
		return

	var line := await dialogue.get_next_dialogue_line(line_id)
	
	conversation.set_line(line)
	current_dialogue = dialogue
	next_line = line.next_id

func show_next_line():	
	show_line(current_dialogue, next_line)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			show_next_line()
