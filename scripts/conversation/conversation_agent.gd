class_name ConversationAgent
extends Node

var current_dialogue: DialogueResource
var next_line

func start_conversation(dialogue: DialogueResource, line_id: String):
	show_line(dialogue, line_id)
	(%Time as GameTime).seconds_per_day = 60 * 2 * 10

func _on_conversation_end():
	(%Time as GameTime).seconds_per_day = 60 * 2

func show_line(dialogue: DialogueResource, line_id):
	var conversation: ConversationBox = %ConversationBox
	
	if not line_id or not dialogue:
		conversation.set_line(null)
		
		current_dialogue = null
		next_line = null
		
		_on_conversation_end()
		
		return

	var line := await dialogue.get_next_dialogue_line(line_id)
	
	conversation.set_line(line)
	current_dialogue = dialogue
	
	if line:
		next_line = line.next_id
	else:
		next_line = null

func end_line():
	show_line(current_dialogue, next_line)

func proceed():
	var conversation: ConversationBox = %ConversationBox
	
	if conversation.label.is_typing:
		conversation.label.skip_typing()
	else:
		end_line()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			proceed()
