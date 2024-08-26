class_name Level2
extends Level

@export var me: Node2D
@export var bug: Node2D
@export var bug_path: MultiSpline

@export var snake: Node2D

@export var ants_talk_button: BaseButton

@export var berry: Node2D
@export var berry_path: MultiSpline
@export var bird: Node2D
@export var bird_path: MultiSpline

func think(line_id: String):
	offer_conversation(me.get_node("Button"), line_id)

func dismiss_think():
	dismiss_conversation(me.get_node("Button"))

func enter_snake(line_id: String):
	Events.event_started.emit("see-snake")
	
	var parent := snake
	var model := parent.get_node("Model")
	var button := parent.get_node("Button")

	model.scale = Vector2(0.95, 0.95)
	parent.visible = true

	var tween := create_tween()
	tween.tween_property(model, "scale", Vector2(1, 1), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(1.0)
	tween.play()

func exit_snake():
	var parent := snake
	var model := parent.get_node("Model")
	var button := parent.get_node("Button")

	dismiss_conversation(button)

	var tween := create_tween()
	tween.tween_property(model, "scale", Vector2(0.95, 0.95), 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(parent, "visible", false, 0)
	tween.tween_callback(func(): Events.event_ended.emit("see-snake"))
	tween.play()

func enter_bug(line_id: String):
	Events.event_started.emit("see-bug")
	
	var parent := bug
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	set_position_along_multispline(0, parent, bug_path)
	set_is_x_flipped(parent, false)
	parent.visible = true
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path), 0.0, 1.0, 5)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path), 1.0, 2.0, 0.35).set_delay(1)
	tween.tween_callback(offer_conversation.bind(button, line_id))
	tween.play()
	
func exit_bug():
	var parent := bug
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	set_is_x_flipped(parent, true)
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path), 2.0, 1.0, 0.35).set_delay(0.8)
	tween.tween_property(wobbler, "is_wobbling", true, 0).set_delay(1)
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path), 1.0, 0.0, 5)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.tween_callback(func(): Events.event_ended.emit("see-bug"))
	tween.play()

func enter_ants(line_id: String):
	offer_conversation(ants_talk_button, line_id)

func dismiss_ants():
	dismiss_conversation(ants_talk_button)

func enter_berry():
	var parent := berry
	var model := parent.get_node("Model") as Node2D
	
	set_position_along_multispline(0, parent, berry_path)
	parent.visible = true
	
	var tween := create_tween()
	tween.set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(set_position_along_multispline.bind(parent, berry_path), 0.0, 1, 2.5)
	tween.tween_property(model, "rotation", -PI * 4, 2.5)
	tween.play()

func bird_pick_berry():
	var parent := bird
	var berry := berry

	set_position_along_multispline(0, parent, bird_path)
	parent.visible = true
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_method(set_position_along_multispline.bind(parent, bird_path), 0.0, 1, 1.5).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): berry.reparent(parent); parent.move_child(berry, 0))
	tween.tween_method(set_position_along_multispline.bind(parent, bird_path), 1.0, 0, 1.0).set_ease(Tween.EASE_IN).set_delay(0.5)
	tween.play()
