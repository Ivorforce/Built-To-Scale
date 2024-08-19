class_name ConversationAgent
extends Node

var current_dialogue: DialogueResource
var next_line

@onready
var time := %Time as GameTime

@onready
var conversation_box := %ConversationBox as ConversationBox

func start_conversation_if_idle(dialogue: DialogueResource, line_id: String):
	if current_dialogue:
		return false
	
	start_conversation(dialogue, line_id)
	return true

func start_conversation(dialogue: DialogueResource, line_id: String):
	show_line(dialogue, line_id)
	time.is_talking = true

func _on_conversation_end():
	time.is_talking = false

func show_line(dialogue: DialogueResource, line_id):	
	if not line_id or not dialogue:
		conversation_box.set_line(null)
		
		current_dialogue = null
		next_line = null
		
		_on_conversation_end()
		
		return

	var line := await dialogue.get_next_dialogue_line(line_id)
	
	conversation_box.set_line(line)
	current_dialogue = dialogue
	
	if line:
		next_line = line.next_id
	else:
		next_line = null

func end_line():
	show_line(current_dialogue, next_line)

func proceed():
	if conversation_box.label.is_typing:
		conversation_box.label.skip_typing()
	else:
		end_line()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			proceed()
