extends Button

const game = preload("res://scenes/game/game.tscn")

func _pressed() -> void:
	get_tree().change_scene_to_packed(game)
