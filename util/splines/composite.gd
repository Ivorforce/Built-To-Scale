class_name CompositeSpline
extends MultiSpline

func sample_multispline(p: float) -> Vector2:
	var child_count := get_child_count()
	
	if child_count == 0:
		return global_position
	
	for child_idx in child_count:
		var spline: MultiSpline = get_child(child_idx) as MultiSpline
		var spline_length := spline.get_multispline_length()
		
		if p <= spline_length or child_idx == child_count - 1:
			return spline.sample_multispline(p)
		else:
			p -= spline_length
	
	assert(false)
	return Vector2.ZERO

func get_multispline_length() -> int:
	var length := 0
	
	for child in get_children():
		var spline: MultiSpline = child as MultiSpline
		length += spline.get_multispline_length()

	return length
