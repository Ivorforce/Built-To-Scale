class_name Level2
extends Node2D

var conversation_agent: ConversationAgent
var time: GameTime

func offer_test_dialogue():
	var bug := %Bug as Node2D
	var walker_path := get_node("%Bug/WalkerPath") as SplineWalker
	var walker_jump := get_node("%Bug/WalkerJump") as SplineWalker
	var wobbler := bug.get_node("Model/Wobbler") as Wobbler

	walker_path.position = 0
	bug.scale.x = abs(bug.scale.x)
	bug.visible = true
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_property(walker_path, "position", walker_path.path.get_length(), 5)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.tween_property(walker_jump, "position", walker_jump.path.get_length(), 0.35).set_delay(1)
	tween.play()

	#tween.tween_property(snake, "scale", Vector2(0.125, 0.125), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	
func dismiss_test_dialogue():
	var bug := %Bug as Node2D
	var walker_path := get_node("%Bug/WalkerPath") as SplineWalker
	var walker_jump := get_node("%Bug/WalkerJump") as SplineWalker
	var wobbler := bug.get_node("Model/Wobbler") as Wobbler

	bug.scale.x = -abs(bug.scale.x)
	
	var tween := create_tween()
	tween.tween_property(walker_jump, "position", 0, 0.35).set_delay(0.8)
	tween.tween_property(wobbler, "is_wobbling", true, 0).set_delay(1)
	tween.tween_property(walker_path, "position", 0, 5)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.play()
