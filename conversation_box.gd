class_name ConversationBox
extends Control

@onready
var tween := get_tree().create_tween()

func set_text(text: String):
	var label :RichTextLabel = $ConversationLabel
	
	tween.stop()
	
	label.visible_ratio = 0
	label.text = text
	tween.tween_property(label, "visible_ratio", 1, 3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.play()
