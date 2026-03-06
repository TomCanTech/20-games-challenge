class_name Score
extends RichTextLabel

@export var goal: Area2D

@onready var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal.body_entered.connect(_update_score)
	text = str(score)


func _update_score(body: Node2D) -> void:
	if body.is_in_group("Paddles"): return
	
	score += 1
	text = str(score)
