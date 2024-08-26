class_name SplineWalker
extends Node

@export
var path: Node

var position: float:
	set(new_position):
		position = new_position
		get_parent().global_transform.origin = path.sample_multispline(new_position)

func run_tween(duration: float, ease: Tween.EaseType):
	var length = path.get_length()
	
	position = 0
	
	var tween := create_tween()
	tween.tween_property(self, "position", length, duration)
	tween.play()
