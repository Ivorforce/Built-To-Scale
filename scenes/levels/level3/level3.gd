class_name Level3
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

func zoom_out():
	var camera := %Camera2D as Camera2D
	var walker := camera.get_node("Walker") as SplineWalker
	
	# Broken!
	#var tween := create_tween()
	#tween.set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#tween.tween_property(camera, "zoom", Vector2(1, 1), 5)
	#tween.tween_property(walker, "position", 1, 1.5)
	#tween.play()
