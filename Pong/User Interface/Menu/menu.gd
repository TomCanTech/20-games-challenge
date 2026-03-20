extends Control

@export var node_array: Array[Node]
@export var ai_paddle: Paddle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/StartButton.pressed.connect(_start_pressed)
	$MarginContainer/VBoxContainer/AIButton.pressed.connect(_ai_pressed)
	$MarginContainer/VBoxContainer/ResetButton.pressed.connect(_reset_pressed)
	$MarginContainer/VBoxContainer/QuitButton.pressed.connect(_quit_pressed)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_menu"):
		_toggle_menu()
		
	if !visible and get_tree().paused == true:
		if (
			Input.is_action_just_pressed("player_one_up") 
			or Input.is_action_just_pressed("player_one_down")
			or (Input.is_action_just_pressed("player_two_up") and ai_paddle.player_num != 2)
			or (Input.is_action_just_pressed("player_two_down") and ai_paddle.player_num != 2)
			):
				get_tree().paused = false


func _start_pressed() -> void:
	hide()
	$MarginContainer/VBoxContainer/StartButton.text = "Continue"


func _ai_pressed() -> void:
	if ai_paddle.player_num == 2:
		$MarginContainer/VBoxContainer/AIButton.text = "Enable Bot"
		ai_paddle.player_num = 1
	else: 
		$MarginContainer/VBoxContainer/AIButton.text = "Disable Bot"
		ai_paddle.player_num = 2
	
	_reset_pressed()


func _reset_pressed() -> void:
	$MarginContainer/VBoxContainer/StartButton.text = "Start Game"
	for node in node_array:
		if node.has_method("reset"):
			node.reset()


func _quit_pressed() -> void:
	get_tree().quit()


func _toggle_menu() -> void:
	if !visible:
		get_tree().paused = true
		show()
	else:
		get_tree().paused = false
		hide()
