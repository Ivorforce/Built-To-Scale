class_name Level1
extends Node2D

var conversation_agent: ConversationAgent

func offer_test_dialogue():
	var bug := %Bug as Node2D
	var walker := get_node("%Bug/Walker") as SplineWalker
	var wobbler := bug.get_node("Model/Wobbler") as Wobbler

	walker.position = 0
	bug.scale.x = abs(bug.scale.x)
	bug.visible = true
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", walker.path.get_length(), 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.play()

	#tween.tween_property(snake, "scale", Vector2(0.125, 0.125), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	
func dismiss_test_dialogue():
	var bug := %Bug as Node2D
	var walker := bug.get_node("Walker") as SplineWalker
	var wobbler := bug.get_node("Model/Wobbler") as Wobbler

	bug.scale.x = -abs(bug.scale.x)
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 0, 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.play()
	
	#tween.tween_property(snake, "scale", Vector2(0.13, 0.13), 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	#tween.tween_property(snake, "visible", false, 0)
