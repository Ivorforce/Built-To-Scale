class_name GameTime
extends Node

@export
var previous_time_h := 0.0
@export
var current_time_h := 0.0
@export
var current_day := 0

@export
var seconds_per_hour := 60.0
@export
var paused := true
@export
var speed_factor := 1.0

func _process(delta: float) -> void:
	if paused:
		return
	
	var time_delta := delta / seconds_per_hour * speed_factor
	
	previous_time_h = current_time_h
	current_time_h += time_delta
	
	if current_time_h >= 24:
		current_day += int(current_time_h / 24)
		current_time_h = fmod(current_time_h, 24)
