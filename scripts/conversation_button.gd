extends Button

@export
var entity_name: String
@export
var resource: DialogueResource
@export
var start_line_id: String

func _pressed() -> void:
	var agent: ConversationAgent = %ConversationAgent
	
	if agent.current_dialogue:
		return
	
	agent.show_line(resource, start_line_id)
