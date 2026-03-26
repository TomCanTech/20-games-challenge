extends Control

@export var node_array: Array[Node]
@export var ai_paddle: Paddle

@onready var start_button: Button = $MarginContainer/VBoxContainer/StartButton
@onready var ai_button: Button = $MarginContainer/VBoxContainer/AIButton
@onready var reset_button: Button = $MarginContainer/VBoxContainer/ResetButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton


func _ready() -> void:
	start_button.pressed.connect(_start_pressed)
	ai_button.pressed.connect(_ai_pressed)
	reset_button.pressed.connect(_reset_pressed)
	quit_button.pressed.connect(_quit_pressed)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_menu"):
		_toggle_menu()
		
	var player_one_input = Input.is_action_just_pressed("player_one_up") or Input.is_action_just_pressed("player_one_down")
	var player_two_input = Input.is_action_just_pressed("player_two_up") or Input.is_action_just_pressed("player_two_down")
	var bot_active = (ai_paddle.player_num == Paddle.Player.AI)
	
	if (
		!visible and get_tree().paused == true
		and (player_one_input or (player_two_input and not bot_active))
	):
		get_tree().paused = false
		


func _start_pressed() -> void:
	hide()
	start_button.text = "Continue Game"


func _ai_pressed() -> void:
	if ai_paddle.player_num == 2:
		ai_button.text = "Enable Bot"
		ai_paddle.player_num = Paddle.Player.PLAYER_2
	else: 
		ai_button.text = "Disable Bot"
		ai_paddle.player_num = Paddle.Player.AI
	
	_reset_pressed()


func _reset_pressed() -> void:
	start_button.text = "Start Game"
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
