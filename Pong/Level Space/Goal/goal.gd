extends Area2D
class_name Goal

signal goal_entered

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	body_entered.connect(on_goal_entered)


func on_goal_entered(body: Node2D):
	if !body.is_in_group("Ball"): 
		return
	
	goal_entered.emit()
	audio_stream_player.play()
	
	if body.has_method("reset"):
		body.reset()
		get_tree().paused = true
