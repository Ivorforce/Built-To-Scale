extends Camera2D

@onready
var center_origin: Vector2 = transform.get_origin()

func _physics_process(delta: float) -> void:	
	var relative_position := get_viewport().get_mouse_position() / Vector2(get_viewport().size) - Vector2(0.5, 0.5)
	
	relative_position = relative_position.clampf(-0.5, 0.5)
	
	var target_origin := center_origin + relative_position * Vector2(40, 20)
	transform.origin = transform.origin.lerp(target_origin, 0.1)
