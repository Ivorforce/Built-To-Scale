class_name ConversationBox
extends Control

@onready
var label: DialogueLabel = $ConversationLabel

func set_line(line: DialogueLine):
	if not line:
		label.visible = false
		return
	
	label.visible = true
	label.dialogue_line = line
	label.type_out()
