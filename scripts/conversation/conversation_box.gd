class_name ConversationBox
extends Control

@onready
var tween := get_tree().create_tween()

func set_line(line: DialogueLine):
	var label: DialogueLabel = $ConversationLabel
	
	label.dialogue_line = line
	label.type_out()
