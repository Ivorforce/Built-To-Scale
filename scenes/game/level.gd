class_name Level
extends Node2D

var conversation_agent: ConversationAgent

@export
var dialogue: DialogueResource

func set_position_along_multispline(position: float, node: Node2D, path: MultiSpline):
	node.global_transform.origin = path.sample_multispline(position)

func reconnect(signal_: Signal, callable: Callable):
	for connection in signal_.get_connections():
		signal_.disconnect(connection["callable"])
	signal_.connect(callable)

func start_conversation(button: Button, line_id: String):
	if conversation_agent.start_conversation_if_idle(dialogue, line_id):
		button.visible = false
		Events.event_ended.emit(button)

func offer_conversation(button: Button, line_id: String):
	reconnect(button.pressed, start_conversation.bind(button, line_id))
	button.visible = true
	Events.event_started.emit(button)

func dismiss_conversation(button: Button):
	button.visible = false
	Events.event_ended.emit(button)
