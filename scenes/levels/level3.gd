class_name Level3
extends Node2D

var conversation_agent: ConversationAgent

func offer_test_dialogue():
	var button := %Mothertree/Button
	var dialogue := load("res://texts/test.dialogue")
	
	button.pressed.connect(func(): start_conversation(button, dialogue, "start"))
	button.visible = true

func start_conversation(button: Button, dialogue: DialogueResource, start_line_id: String):
	if conversation_agent.start_conversation_if_idle(dialogue, start_line_id):
		button.visible = false

func dismiss_test_dialogue():
	var button := %Mothertree/Button
	button.visible = false
