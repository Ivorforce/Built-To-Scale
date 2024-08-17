class_name GameTime
extends Node

signal on_day_start
signal on_day_end

@export
var previous_time_h := 8.0
@export
var current_time_h := 8.0

@export
var seconds_per_day := 60.0 * 2.0
@export
var day_is_over := false

func _ready() -> void:
	start_day()

func start_day():
	previous_time_h = 8
	current_time_h = 8
	on_day_start.emit()

func _process(delta: float) -> void:
	previous_time_h = current_time_h
	current_time_h += 12 * delta / seconds_per_day
	
	if not day_is_over and current_time_h > 20:
		day_is_over = true
		on_day_end.emit()
