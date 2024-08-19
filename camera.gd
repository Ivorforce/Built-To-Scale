extends Camera2D

@onready
var center_origin: Vector2 = transform.get_origin()

@export
var screenshake_trauma := 0.0
@export
var trauma_power := 2

@onready
var noise := FastNoiseLite.new()
var noise_y := 0

@export var decay := 0.8
@export var max_offset := Vector2(100, 75)
@export var max_roll := 0.03

func _ready() -> void:
	randomize()
	noise.seed = randi() / 10000
	noise.frequency = 1
	noise.fractal_octaves = 2

func _physics_process(delta: float) -> void:	
	var relative_position := get_viewport().get_mouse_position() / Vector2(get_viewport().size) - Vector2(0.5, 0.5)
	
	relative_position = relative_position.clampf(-0.5, 0.5)
	
	var target_origin := center_origin + relative_position * Vector2(40, 20)
	transform.origin = transform.origin.lerp(target_origin, 0.1)
	
	if screenshake_trauma > 0:
		noise_y += delta * 500
		var amount = pow(screenshake_trauma, trauma_power)
		rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
		offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
		offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
