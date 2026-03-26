class_name Ball
extends AnimatableBody2D

@export var direction: Vector2 = Vector2.ZERO
@export var speed: float = 500

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var initial_pos: Vector2 = self.position

func _ready() -> void:
	if speed <= 0:
		push_warning("The ball must be given a speed greater than 0.")
	
	if direction == Vector2.ZERO:
		direction = _generate_vector()
	else:
		direction = direction.normalized()


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(direction * speed * delta)
	if collision == null:
		return
	else:
		if (collision.get_collider() as Node).is_in_group("Paddles"):
			audio_stream_player.volume_db = -20
			direction = _paddle_bounce(collision)
		else:
			audio_stream_player.volume_db = -25
			direction = direction.bounce(collision.get_normal()).normalized()
		
		audio_stream_player.play()


func _generate_vector() -> Vector2:
	var rand_angle: float = randf_range(0,PI/4)
	var rand_horizontal: int = randi_range(0,1)	
	var rand_vertical: int = randi_range(0,1)
	
	return Vector2.from_angle(rand_angle + (((3*PI)/4) * rand_horizontal) + (PI * rand_vertical)).normalized()


func _paddle_bounce(collision: KinematicCollision2D) -> Vector2:
	var colliding_body_pos = (collision.get_collider() as Node2D).get_position()
	var vector_from_collider = (position - colliding_body_pos)
	
	return vector_from_collider.normalized()


func reset() -> void:
	position = initial_pos
	direction = _generate_vector()
