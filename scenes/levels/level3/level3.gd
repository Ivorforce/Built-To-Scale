class_name Level3
extends Level

func think(line_id: String):
	offer_conversation(%Me/Button, line_id)

func dismiss_think():
	dismiss_conversation(%Me/Button)

func zoom_out():
	var camera := %Camera2D as Camera2D
	var walker := camera.get_node("Walker") as SplineWalker
	
	# Broken!
	#var tween := create_tween()
	#tween.set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#tween.tween_property(camera, "zoom", Vector2(1, 1), 5)
	#tween.tween_property(walker, "position", 1, 1.5)
	#tween.play()
