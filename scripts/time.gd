class_name GameTime
extends Node

@export
var previous_time_h := 0.0
## May have a value larger than 24. In that case, it is the night of the previous day, not
## the morning of the next day. It will get resolved sooner or later.
@export
var current_time_h := 0.0

@export
var seconds_per_hour := 60.0
@export
var paused := true
@export
var is_talking := false
@export
var potential_talkmate_count := 0

func _process(delta: float) -> void:
	if paused:
		return
	
	var time_delta := delta / seconds_per_hour
	
	if is_talking:
		time_delta = time_delta * 0.05
	elif potential_talkmate_count > 0:
		time_delta = time_delta * 0.15
	
	previous_time_h = current_time_h
	current_time_h = current_time_h + time_delta
