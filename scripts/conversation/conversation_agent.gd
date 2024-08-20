class_name ConversationAgent
extends Node

var current_dialogue: DialogueResource
var next_line

@onready
var time := %Time as GameTime

@onready
var conversation_box := %ConversationBox as ConversationBox

var ticks_since_autoend_msec := -1

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
	assert(line_id)
	assert(dialogue)

	var line := await dialogue.get_next_dialogue_line(line_id)
	
	conversation_box.set_line(line)
	current_dialogue = dialogue
	
	if line:
		next_line = line.next_id
	else:
		current_dialogue = null
		next_line = null
		_on_conversation_end()

func end_line():
	show_line(current_dialogue, next_line)

func proceed():
	if not current_dialogue:
		return
	
	if conversation_box.label.is_typing:
		conversation_box.label.skip_typing()
	else:
		end_line()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			if Time.get_ticks_msec() < ticks_since_autoend_msec + 200:
				# Debounce clicks to avoid accidental skips
				return
			
			proceed()

func _on_conversation_label_finished_typing() -> void:
	ticks_since_autoend_msec = Time.get_ticks_msec()
