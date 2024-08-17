class_name PostProcess
extends Sprite2D

func set_tint_color(color: Color):
	(material as ShaderMaterial).set_shader_parameter("tint_color", color)
