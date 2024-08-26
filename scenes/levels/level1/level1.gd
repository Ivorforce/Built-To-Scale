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
	time.potential_talkmate_count += 1
	
	var parent := bug
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	set_position_along_multispline(0, parent, bug_path)
	parent.scale.x = abs(parent.scale.x)
	parent.visible = true
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path), 0.0, 1.0, 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(1.0)
	tween.play()
	
func exit_bug():
	time.potential_talkmate_count -= 1
	
	var parent := bug
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	parent.scale.x = -abs(parent.scale.x)
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, bug_path), 1.0, 0, 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.play()
	
func enter_moth_top(line_id: String):
	var parent := moth
	var button := parent.get_node("Button")

	set_position_along_multispline(0, parent, moth_path)
	parent.rotation = 0
	parent.scale.y = abs(parent.scale.y)
	parent.visible = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, moth_path), 0.0, 1, 2)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(0.1)
	tween.play()
	
func exit_moth_bottom():
	var parent := moth
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	parent.rotation = PI
	parent.scale.y = -abs(parent.scale.y)
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, moth_path), 1.0, 2, 2)
	tween.play()
	
func enter_moth_bottom(line_id: String):
	var parent := moth
	var button := parent.get_node("Button")

	set_position_along_multispline(2, parent, moth_path)
	parent.rotation = 0
	parent.scale.y = abs(parent.scale.y)

	parent.visible = true
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, moth_path), 2.0, 1, 2)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(0.1)
	tween.play()
	
func exit_moth_top():
	var parent := moth
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	parent.rotation = PI
	parent.scale.y = -abs(parent.scale.y)
	
	var tween := create_tween()
	tween.tween_method(set_position_along_multispline.bind(parent, moth_path), 1.0, 0, 2)
	tween.play()
	
