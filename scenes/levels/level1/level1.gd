class_name Level1
extends Level

@export var me: Node2D
@export var bug: Node2D
@export var bug_path: MultiSpline
@export var moth: Node2D
@export var moth_path: MultiSpline

func think(line_id: String):
	offer_conversation(me.get_node("Button"), line_id)

func dismiss_think():
	dismiss_conversation(me.get_node("Button"))

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
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path), 0.0, 1.0, 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(1.0)
	tween.play()
	
func exit_bug():
	var parent := bug
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	set_is_x_flipped(parent, true)
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path), 1.0, 0, 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.tween_callback(func(): Events.event_ended.emit("see-bug"))
	tween.play()
	
func enter_moth_top(line_id: String):
	Events.event_started.emit("see-moth")
	
	var parent := moth
	var button := parent.get_node("Button")

	set_position_along_multispline(0, parent, moth_path)
	set_is_x_flipped(parent, false)
	parent.visible = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, moth_path), 0.0, 1, 2)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(0.1)
	tween.play()
	
func exit_moth_bottom():
	var parent := moth
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	set_is_x_flipped(parent, true)
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, moth_path), 1.0, 2, 2)
	tween.tween_callback(func(): Events.event_ended.emit("see-moth"))
	tween.play()
	
func enter_moth_bottom(line_id: String):
	Events.event_started.emit("see-moth")
	
	var parent := moth
	var button := parent.get_node("Button")

	set_position_along_multispline(2, parent, moth_path)
	set_is_x_flipped(parent, false)

	parent.visible = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, moth_path), 2.0, 1, 2)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(0.1)
	tween.play()
	
func exit_moth_top():
	var parent := moth
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	set_is_x_flipped(parent, true)
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, moth_path), 1.0, 0, 2)
	tween.tween_callback(func(): Events.event_ended.emit("see-moth"))
	tween.play()
	
