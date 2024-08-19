class_name Level1
extends Node2D

@onready
var conversation_agent: ConversationAgent = get_node("/root/Game/%ConversationAgent")

func offer_test_dialogue():
	var snake := %Bug as Node2D
	snake.scale = Vector2(0.13, 0.13)
	snake.visible = true
	var tween := create_tween()
	tween.tween_property(snake, "scale", Vector2(0.125, 0.125), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.play()

func dismiss_test_dialogue():
	var snake := %Bug as Node2D
	var tween := create_tween()
	tween.tween_property(snake, "scale", Vector2(0.13, 0.13), 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(snake, "visible", false, 0)
	tween.play()
