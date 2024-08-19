class_name LinearMultiSpline2D
extends Node2D

func sample_multispline(p: float) -> Vector2:
	if p <= 0:
		return global_transform.origin
		
	var length := get_length()
	if length == 0:
		return global_transform.origin
	
	if p >= length:
		return (get_child(get_child_count() - 1) as Node2D).global_transform.origin
	
	var start_idx := int(p)
	return lerp(
		get_control_point(start_idx),
		get_control_point(start_idx + 1),
		fmod(p, 1)
	)
	self.rotation_degrees

func get_control_point(idx: int) -> Vector2:
	if idx == 0:
		return global_transform.origin
	
	return (get_child(idx - 1) as Node2D).global_transform.origin

func get_length() -> int:
	return get_child_count()
