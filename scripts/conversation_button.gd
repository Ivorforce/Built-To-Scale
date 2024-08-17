class_name ConversationButton
extends Button

@export
var resource: DialogueResource
var start_line_id: String

func _ready() -> void:
	visible = false

func offer_conversation(resource: DialogueResource, start_line_id: String):
	self.resource = resource
	self.start_line_id = start_line_id
	visible = true

func dismiss_conversation():
	visible = false

func _pressed() -> void:
	var agent: ConversationAgent = %ConversationAgent
	
	if agent.current_dialogue:
		return
	
	agent.start_conversation(resource, start_line_id)
	visible = false
