class_name Floater
extends Node

@export
var is_floating := false:
	set(new_value):
		if not new_value:
			(get_parent() as Node2D).position.y = 0
			time = 0
		
		is_floating = new_value
		set_process(new_value)

var time = 0

@export
var float_distance := 5

@export
var cycle_duration_s := 1

func _ready() -> void:
	set_process(is_floating)

func _process(delta: float) -> void:
	if not is_floating:
		return
	
	time += delta
	(get_parent() as Node2D).position.y = sin(time / cycle_duration_s * PI * 2) * float_distance
