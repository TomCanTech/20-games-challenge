class_name Score
extends RichTextLabel

@export var goal: Area2D

@onready var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal.goal_entered.connect(_update_score)
	text = str(score)


func _update_score() -> void:
	score += 1
	text = str(score)


func reset() -> void:
	text = str(0)
