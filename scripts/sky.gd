class_name GameSky
extends Sprite2D

@export
var day_gradient: Gradient
@export
var day_gradient_tint: Gradient

@export
var day_start_h := 7.0

@export
var day_duration_h := 14.0

func sample_gradient(gradient: Gradient, ratio: float) -> Color:
	for idx in range(gradient.get_point_count() - 1):
		var offset_next := gradient.offsets[idx + 1]
		if offset_next > ratio:
			var offset_prev := gradient.offsets[idx]
			var part_ratio := (ratio - offset_prev) / (offset_next - offset_prev)
			return gradient.colors[idx].lerp(gradient.colors[idx + 1], part_ratio)
			
	return gradient.colors[-1]

func _process(delta: float) -> void:
	var day_ratio := fmod((%Time as GameTime).current_time_h - day_start_h, 24) / day_duration_h
	day_ratio = clampf(day_ratio, 0, 1)
	
	var zenith_ratio = (0.5 - abs(day_ratio - 0.5)) * 2
	
	(texture as GradientTexture1D).gradient.colors[0] = sample_gradient(day_gradient, zenith_ratio)
	(%PostProcess as PostProcess).set_tint_color(sample_gradient(day_gradient_tint, zenith_ratio))
