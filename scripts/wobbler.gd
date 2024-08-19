class_name Wobbler
extends Node

@export
var is_wobbling := false:
	set(new_is_wobbling):
		if not new_is_wobbling:
			get_parent().rotation_degrees = neutral_position_deg
			time = 0
		
		is_wobbling = new_is_wobbling
		set_process(new_is_wobbling)

var time = 0

@export
var wobble_rotation_deg := 5
@export
var wobble_center_deg := 0
@export
var neutral_position_deg := 0

@export
var wobble_duration_s := 0.3

func _ready() -> void:
	set_process(is_wobbling)

func _process(delta: float) -> void:
	if not is_wobbling:
		return
	
	time += delta
	get_parent().rotation_degrees = wobble_center_deg + ((int(time / wobble_duration_s) % 2) * 2 - 1) * wobble_rotation_deg
