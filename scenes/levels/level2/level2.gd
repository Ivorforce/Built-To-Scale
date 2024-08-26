class_name Level2
extends Level

@export var me: Node2D
@export var bug: Node2D
@export var bug_path_walk: MultiSpline
@export var bug_path_jump: MultiSpline

@export var berry_path: MultiSpline
@export var bird_path: MultiSpline

func think(line_id: String):
	offer_conversation(%Me/Button, line_id)

func dismiss_think():
	dismiss_conversation(%Me/Button)

func enter_snake(line_id: String):
	var parent := %Snake as Node2D
	var model := parent.get_node("Model")
	var button := parent.get_node("Button")

	model.scale = Vector2(0.95, 0.95)
	parent.visible = true

	var tween := create_tween()
	tween.tween_property(model, "scale", Vector2(1, 1), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(1.0)
	tween.play()

func exit_snake():
	var parent := %Snake as Node2D
	var model := parent.get_node("Model")
	var button := parent.get_node("Button")

	dismiss_conversation(button)

	var tween := create_tween()
	tween.tween_property(model, "scale", Vector2(0.95, 0.95), 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(parent, "visible", false, 0)
	tween.play()

func enter_bug(line_id: String):
	time.potential_talkmate_count += 1
	
	var parent := %Bug as Node2D
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	set_position_along_multispline(0, parent, bug_path_walk)
	parent.scale.x = abs(parent.scale.x)
	parent.visible = true
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path_walk), 0.0, 1, 5)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path_jump), 0.0, 1, 0.35).set_delay(1)
	tween.tween_callback(offer_conversation.bind(button, line_id))
	tween.play()
	
func exit_bug():
	time.potential_talkmate_count -= 1
	
	var parent := %Bug as Node2D
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	parent.scale.x = -abs(parent.scale.x)
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path_jump), 1.0, 0, 0.35).set_delay(0.8)
	tween.tween_property(wobbler, "is_wobbling", true, 0).set_delay(1)
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path_walk), 1.0, 0, 5)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.play()

func enter_ants(line_id: String):
	offer_conversation(%AntsTalkButton, line_id)

func dismiss_ants():
	dismiss_conversation(%AntsTalkButton)

func enter_berry():
	var parent := %Berry as Node2D
	var model := parent.get_node("Model") as Node2D
	
	set_position_along_multispline(0, parent, berry_path)
	parent.visible = true
	
	var tween := create_tween()
	tween.set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(set_position_along_multispline.bind(parent, berry_path), 0.0, 1, 2.5)
	tween.tween_property(model, "rotation", -PI * 4, 2.5)
	tween.play()

func bird_pick_berry():
	var parent := %Bird as Node2D
	var berry := %Berry as Node2D

	set_position_along_multispline(0, parent, bird_path)
	parent.visible = true
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_method(set_position_along_multispline.bind(parent, bird_path), 0.0, 1, 1.5).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): berry.reparent(parent); parent.move_child(berry, 0))
	tween.tween_method(set_position_along_multispline.bind(parent, bird_path), 1.0, 0, 1.0).set_ease(Tween.EASE_IN).set_delay(0.5)
	tween.play()
