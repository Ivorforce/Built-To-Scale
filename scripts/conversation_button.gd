extends Button

@export
var entity_name: String
@export
var resource: DialogueResource
@export
var start_line_id: String

func _pressed() -> void:
	%ConversationAgent.show_line(resource, start_line_id)
