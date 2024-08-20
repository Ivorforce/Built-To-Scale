class_name Level1
extends Node2D

var conversation_agent: ConversationAgent
var time: GameTime

@onready
var dialogue := preload("res://texts/level1.dialogue")

func start_conversation(button: Button, dialogue: DialogueResource, start_line_id: String):
	if conversation_agent.start_conversation_if_idle(dialogue, start_line_id):
		button.visible = false
		time.potential_talkmate_count -= 1

func think_hello_world():
	var button := %Me/Button
	button.pressed.connect(func(): start_conversation(button, dialogue, "hello_world"))
	button.visible = true
	time.potential_talkmate_count += 1

func dismiss_think_hello_world():
	var button := %Me/Button
	button.visible = false
	time.potential_talkmate_count -= 1

func enter_bug():
	var bug := %Bug as Node2D
	var walker := bug.get_node("Walker") as SplineWalker
	var wobbler := bug.get_node("Model/Wobbler") as Wobbler

	walker.position = 0
	bug.scale.x = abs(bug.scale.x)
	bug.visible = true
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", walker.path.get_length(), 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.play()

	#tween.tween_property(snake, "scale", Vector2(0.125, 0.125), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	
func exit_bug():
	var bug := %Bug as Node2D
	var walker := bug.get_node("Walker") as SplineWalker
	var wobbler := bug.get_node("Model/Wobbler") as Wobbler

	bug.scale.x = -abs(bug.scale.x)
	wobbler.is_wobbling = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 0, 3)
	tween.tween_property(wobbler, "is_wobbling", false, 0)
	tween.play()
	
	#tween.tween_property(snake, "scale", Vector2(0.13, 0.13), 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	#tween.tween_property(snake, "visible", false, 0)

func enter_moth_first():
	var bug := %Moth as Node2D
	var walker := bug.get_node("Walker") as SplineWalker

	walker.position = 0
	bug.rotation = 0
	bug.scale.y = abs(bug.scale.y)
	bug.visible = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 1, 2)
	tween.play()
	
func exit_moth_first():
	var bug := %Moth as Node2D
	var walker := bug.get_node("Walker") as SplineWalker

	bug.rotation = PI
	bug.scale.y = -abs(bug.scale.y)
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 2, 2)
	tween.play()
	
func enter_moth_second():
	var bug := %Moth as Node2D
	var walker := bug.get_node("Walker") as SplineWalker

	walker.position = 2
	bug.rotation = 0
	bug.scale.y = abs(bug.scale.y)

	bug.visible = true
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 1, 2)
	tween.play()
	
func exit_moth_second():
	var bug := %Moth as Node2D
	var walker := bug.get_node("Walker") as SplineWalker

	bug.rotation = PI
	bug.scale.y = -abs(bug.scale.y)
	
	var tween := create_tween()
	tween.tween_property(walker, "position", 0, 2)
	tween.play()
	
