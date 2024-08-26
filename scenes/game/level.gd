class_name Level
extends Node2D

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
