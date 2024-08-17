class_name ConversationBox
extends Control

@onready
var label: DialogueLabel = $ConversationLabel
@onready
var talker_label: Label = $TalkerLabel

func set_line(line: DialogueLine):
	if not line:
		label.visible = false
		talker_label.visible = false
		return
	
	label.dialogue_line = line
	label.type_out()
	label.visible = true

	talker_label.text = line.character
	talker_label.visible = true
