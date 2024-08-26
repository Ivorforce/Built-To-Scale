class_name ConversationBox
extends Control

@onready
var label: DialogueLabel = $ConversationLabel

@onready
var avatar: Node2D = $Avatar

@onready var talk_sound: AudioStreamPlayer = $TalkSound

var last_sound_msec := 0

func set_line(line: DialogueLine):
	if not line:
		self.visible = false
		return
	
	label.dialogue_line = line
	label.type_out()
	
	for node in avatar.get_children():
		node.visible = node.name == line.character
	self.visible = true

func _on_conversation_label_spoke(letter: String, letter_index: int, speed: float) -> void:
	if letter in " .!:?,\t\n":
		return
	
	var current_ticks_msec := Time.get_ticks_msec()
	
	if not talk_sound.finished or (current_ticks_msec - last_sound_msec < 15):
		return
	
	last_sound_msec = current_ticks_msec
	talk_sound.play()
	# Workaround for https://github.com/godotengine/godot/issues/95850
	#  i.e. pitch must be set after play for now.
	talk_sound.pitch_scale = 1 + randf_range(-1, 1) * randf_range(-1, 1) * 0.1
