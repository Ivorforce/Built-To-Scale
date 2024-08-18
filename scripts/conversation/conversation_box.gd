class_name ConversationBox
extends Control

@onready
var label: DialogueLabel = $ConversationLabel

@onready
var avatar: Node2D = $Avatar

@onready var talk_sound: AudioStreamPlayer = $TalkSound


func set_line(line: DialogueLine):
	if not line:
		avatar.visible = false
		label.visible = false
		return
	
	label.dialogue_line = line
	label.type_out()
	label.visible = true
	
	for node in avatar.get_children():
		node.visible = node.name == line.character
	avatar.visible = true

func _on_conversation_label_spoke(letter: String, letter_index: int, speed: float) -> void:
	if letter in " .!:?,\t\n":
		return
	
	if not talk_sound.finished:
		return
	
	talk_sound.pitch_scale = randf_range(0.15, 0.23)
	talk_sound.play()
