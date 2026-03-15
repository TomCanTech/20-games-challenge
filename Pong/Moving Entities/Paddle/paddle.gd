class_name Paddle
extends AnimatableBody2D

@export var player_num: int = -1
@export var speed: float = 500
@export var path_bounds: Array[Vector2]

@export var ai_delay: float = 0.08
@export var ball: Ball

@onready var _path: Vector2 = (path_bounds[1] - path_bounds[0]).normalized()

var _input_axis: float = 0


func _ready() -> void:
	if player_num == -1:
		push_warning("The paddle number is not set. The behaviour of this paddle is undefined.")
	if player_num > 2:
		push_warning("Behaviour is undefined for more than 3 paddles.")
	if path_bounds.size() != 2:
		if path_bounds.size() < 2:
			push_warning("The path bounds are not set. This paddle will not be able to move upon receiving input.")
		if path_bounds.size() > 2:
			push_warning("Too many path bounds have been set. This paddle may only use the first two path bounds.")


func _process(_delta: float) -> void:
	match player_num:
		0:
			_input_axis = Input.get_axis("player_one_up", "player_one_down")
		1:
			_input_axis = Input.get_axis("player_two_up", "player_two_down")
		2:
			_input_ai()
		_:
			_input_axis = Input.get_axis("player_one_up", "player_one_down")


func _physics_process(delta: float) -> void:
	if _input_axis != 0:
		move_and_collide(_path * _input_axis * delta * speed)
		position.x = clampf(position.x, path_bounds[0].x, path_bounds[1].x)
		position.y = clampf(position.y, path_bounds[0].y, path_bounds[1].y)


func _input_ai():
	var ball_pos: Vector2 = ball.position
	var x_offset: float = 30
	
	if ball_pos.x > (position.x - x_offset) and ball_pos.x < (position.x + x_offset):
		_input_axis = 0
		return
	
	await get_tree().create_timer(ai_delay).timeout
	if is_equal_approx(ball_pos.y, position.y):
		_input_axis = 0
	elif ball_pos.y > (position.y + ($CollisionShape2D.shape.get_rect().size.y)/2):
		_input_axis = 1
	elif ball_pos.y < (position.y - ($CollisionShape2D.shape.get_rect().size.y)/2):
		_input_axis = -1
