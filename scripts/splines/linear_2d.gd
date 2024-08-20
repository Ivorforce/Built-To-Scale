class_name LinearMultiSpline2D
extends Node2D

func sample_multispline(p: float) -> Vector2:
	var length := get_length()
	assert(length > 0)
	
	if p <= 0:
		return (get_child(0) as Node2D).global_transform.origin
		
	if p >= length:
		return (get_child(get_child_count() - 1) as Node2D).global_transform.origin
	
	var start_idx := int(p)
	return lerp(
		(get_child(start_idx) as Node2D).global_transform.origin,
		(get_child(start_idx + 1) as Node2D).global_transform.origin,
		fmod(p, 1)
	)

func get_control_point(idx: int) -> Vector2:
	return (get_child(idx) as Node2D).global_transform.origin

func get_length() -> int:
	return get_child_count() - 1
