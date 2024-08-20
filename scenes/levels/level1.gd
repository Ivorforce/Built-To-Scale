class_name Level1
extends Node2D

# ======================= Shared Code, should be superclass!! ===================

var conversation_agent: ConversationAgent
var time: GameTime
@export
var dialogue: DialogueResource

func reconnect(signal_: Signal, callable: Callable):
	for connection in signal_.get_connections():
		signal_.disconnect(connection["callable"])
	signal_.connect(callable)

func start_conversation(button: Button, line_id: String):
	if button.visible and conversation_agent.start_conversation_if_idle(dialogue, line_id):
		button.visible = false
		time.potential_talkmate_count -= 1

func offer_conversation(button: Button, line_id: String):
	reconnect(button.pressed, start_conversation.bind(button, line_id))
	if not button.visible:
		button.visible = true
		time.potential_talkmate_count += 1

func dismiss_conversation(button: Button):
	if button.visible:
		button.visible = false
		time.potential_talkmate_count -= 1

# ======================= END Shared Code ===================

func think(line_id: String):
	offer_conversation(%Me/Button, line_id)

func dismiss_think():
	dismiss_conversation(%Me/Button)

func enter_bug(line_id: String):
	time.potential_talkmate_count += 1
	
	var parent := %Bug as Node2D
	var walker := parent.get_node("Walker") as SplineWalker
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	walker.position = 0
	parent.scale.x = abs(parent.scale.x)
	parent.visible = true
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", walker.path.get_length(), 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(1.0)
	tween.play()
	
func exit_bug():
	time.potential_talkmate_count -= 1
	
	var parent := %Bug as Node2D
	var walker := parent.get_node("Walker") as SplineWalker
	var wobbler := parent.get_node("Model/Wobbler") as Wobbler
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	parent.scale.x = -abs(parent.scale.x)
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 0, 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.play()
	
func enter_moth_top(line_id: String):
	var parent := %Moth as Node2D
	var walker := parent.get_node("Walker") as SplineWalker
	var button := parent.get_node("Button")

	walker.position = 0
	parent.rotation = 0
	parent.scale.y = abs(parent.scale.y)
	parent.visible = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 1, 2)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(0.1)
	tween.play()
	
func exit_moth_bottom():
	var parent := %Moth as Node2D
	var walker := parent.get_node("Walker") as SplineWalker
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	parent.rotation = PI
	parent.scale.y = -abs(parent.scale.y)
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 2, 2)
	tween.play()
	
func enter_moth_bottom(line_id: String):
	var parent := %Moth as Node2D
	var walker := parent.get_node("Walker") as SplineWalker
	var button := parent.get_node("Button")

	walker.position = 2
	parent.rotation = 0
	parent.scale.y = abs(parent.scale.y)

	parent.visible = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 1, 2)
	tween.tween_callback(offer_conversation.bind(button, line_id)).set_delay(0.1)
	tween.play()
	
func exit_moth_top():
	var parent := %Moth as Node2D
	var walker := parent.get_node("Walker") as SplineWalker
	var button := parent.get_node("Button")

	dismiss_conversation(button)
	parent.rotation = PI
	parent.scale.y = -abs(parent.scale.y)
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 0, 2)
	tween.play()
	
