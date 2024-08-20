extends TextureButton

@export
var sound: AudioStreamPlayer

@export
var base_pitch := 1.0

@export
var randomization := 0.01

func _ready():
	texture_click_mask = BitMap.new()
	texture_click_mask.create_from_image_alpha(texture_normal.get_image())

func _pressed() -> void:
	sound.play()
	sound.pitch_scale = base_pitch + randf_range(-1, 1) * randf_range(-1, 1) * randomization
