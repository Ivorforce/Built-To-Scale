class_name ConversationAgent
extends Node

var current_dialogue: DialogueResource
var next_line

func show_line(dialogue: DialogueResource, line_id: String):
	var conversation: ConversationBox = %ConversationBox
	
	if not line_id:
		conversation.set_line(null)
		return

	var line := await dialogue.get_next_dialogue_line(line_id)
	
	conversation.set_line(line)
	
	if line:
		current_dialogue = dialogue
		next_line = line.next_id
	else:
		current_dialogue = null
		next_line = null

func show_next_line():
	if not current_dialogue or not next_line:
		return
	
	show_line(current_dialogue, next_line)

func proceed():
	var conversation: ConversationBox = %ConversationBox
	
	if conversation.label.is_typing:
		conversation.label.skip_typing()
	else:
		show_next_line()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			proceed()
