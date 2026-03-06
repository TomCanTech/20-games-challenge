class_name Ball
extends AnimatableBody2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 500

@onready var initial_pos: Vector2 = self.position

func _ready() -> void:
	if speed <= 0:
		if speed == 0:
			push_warning("No speed was set. The ball will remain stationary.")
		else:
			assert(!(speed < 0), "The ball may not have a negative speed.")
	
	if direction == Vector2.ZERO:
		direction = Vector2.from_angle(_generate_angle()).normalized()
	else:
		direction = direction.normalized()


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D
	var next_dir: Vector2 = direction
	
	collision = move_and_collide(direction * speed * delta)
	if collision == null:
		return
	else:
		if (collision.get_collider() as Node).is_in_group("Paddles"):
			next_dir = _paddle_bounce(collision)
		else:
			next_dir = _bounce(collision)
	
	direction = next_dir


func _generate_angle() -> float:
	var rand_angle: float = randf_range(0,PI/4)
	var rand_horizontal: int = randi_range(0,1)
	var rand_vertical: int = randi_range(0,1)
	
	return rand_angle + (((3*PI)/4) * rand_horizontal) + (PI * rand_vertical)


func _bounce(collision: KinematicCollision2D) -> Vector2:
	return direction.bounce(collision.get_normal()).normalized()


func _paddle_bounce(collision: KinematicCollision2D) -> Vector2:
	var colliding_body_pos = (collision.get_collider() as Paddle).get_position()
	var angle_from_collider = (position - colliding_body_pos).angle()
	return Vector2.from_angle(angle_from_collider).normalized()
