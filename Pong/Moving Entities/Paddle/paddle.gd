class_name Paddle
extends AnimatableBody2D

enum Player {
	PLAYER_1,
	PLAYER_2,
	AI,
	}

@export var player_num: Player = Player.PLAYER_1
@export var speed: float = 500
@export var path_bounds: Array[Vector2]

@export var ai_delay: float = 0.08
@export var ball: Ball
@export var goals: Array[Goal]

var _input_axis: float = 0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var _path: Vector2 = (path_bounds[1] - path_bounds[0]).normalized()
@onready var _centre_of_path: Vector2 = _path_centre()


func _ready() -> void:
	if player_num > 2:
		push_warning("Behaviour is undefined for more than 3 types of player input.")
	
	if path_bounds.size() != 2:
		push_warning("The path must be a straight line defined by exactly 2 bounds.")
	
	for goal in goals:
		goal.goal_entered.connect(reset)
		
	position = _centre_of_path


func _process(_delta: float) -> void:
	match player_num:
		Player.PLAYER_1:
			_input_axis = Input.get_axis("player_one_up", "player_one_down")
		Player.PLAYER_2:
			_input_axis = Input.get_axis("player_two_up", "player_two_down")
		Player.AI:
			_input_ai()
		_:
			_input_axis = Input.get_axis("player_one_up", "player_one_down")


func _physics_process(delta: float) -> void:
	if _input_axis != 0:
		move_and_collide(_path * _input_axis * delta * speed)
		position = position.clamp(path_bounds[0], path_bounds[1])


func _path_centre() -> Vector2:
	var path_sum = Vector2(0,0)
	for path in path_bounds:
		path_sum += path
	var path_avg = path_sum / path_bounds.size()
	return path_avg


func _input_ai():
	var ball_pos: Vector2 = ball.position
	var paddle_y_size = collision_shape_2d.shape.get_rect().size.y
	
	await get_tree().create_timer(ai_delay).timeout
	if is_equal_approx(ball_pos.y, position.y):
		_input_axis = 0
	elif ball_pos.y > (position.y + paddle_y_size/2):
		_input_axis = 1
	elif ball_pos.y < (position.y - paddle_y_size/2):
		_input_axis = -1


func reset() -> void:
	position = _centre_of_path
