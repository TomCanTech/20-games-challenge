extends Area2D
class_name Goal

signal goal_entered()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_goal_entered)


func on_goal_entered(body: Node2D):
	if !body.is_in_group("Ball"): return
	
	goal_entered.emit()
	$AudioStreamPlayer.play()
	if body.has_method("reset"):
		body.reset()
		get_tree().paused = true
