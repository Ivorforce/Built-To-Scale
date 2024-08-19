class_name Level2
extends Node2D

var conversation_agent: ConversationAgent

func offer_test_dialogue():
	var snake := %Snake as Node2D
	snake.scale = Vector2(0.31, 0.31)
	snake.visible = true
	var tween := create_tween()
	tween.tween_property(snake, "scale", Vector2(0.33, 0.33), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.play()

func dismiss_test_dialogue():
	var snake := %Snake as Node2D
	var tween := create_tween()
	tween.tween_property(snake, "scale", Vector2(0.31, 0.31), 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(snake, "visible", false, 0)
	tween.play()
