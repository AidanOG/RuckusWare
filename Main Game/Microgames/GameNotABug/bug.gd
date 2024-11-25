extends CharacterBody2D

@export var behavior_timer: Timer
@export var teleport_timer: Timer

var behavior

var SPEED = 750 * GameManager.game_speed
var direction
var angle
var angular_speed


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.game_level == 1:
		pass
	elif GameManager.game_level == 2:
		teleport_timer.set_wait_time(randf_range(3.0/GameManager.game_speed, 8.0/GameManager.game_speed))
		teleport_timer.start()
	elif GameManager.game_level == 3:
		teleport_timer.set_wait_time(randf_range(1.0/GameManager.game_speed, 4.0/GameManager.game_speed))
		teleport_timer.start()
	
	_on_behavior_timer_timeout()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if behavior == 0:
		velocity = direction * SPEED * delta
		var collision_info = move_and_collide(velocity)
		if collision_info:
			velocity.bounce(collision_info.get_normal())
			direction = direction.bounce(collision_info.get_normal())
		
	if behavior == 1:
		angle += angular_speed * delta
		velocity = Vector2.UP.rotated(angle).normalized() * SPEED * delta
		var collision_info = move_and_collide(velocity)
		if collision_info:
			#velocity.bounce(collision_info.get_normal())
			angle += PI
			angular_speed = randf_range(angular_speed * -0.5, angular_speed * -1.25)
		

func _on_behavior_timer_timeout():
	behavior = randi_range(0, 1)

	if behavior == 0:
		while true:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			if direction != Vector2(0,0):
				break
	
	if behavior == 1:
		angle = randf_range(0, 2 * PI)
		while true:
			angular_speed = randf_range(-3 * PI * GameManager.game_speed, 3 * PI * GameManager.game_speed)
			if angular_speed != 0:
				break
	
	behavior_timer.set_wait_time(randf_range(0.5/GameManager.game_speed, 5/GameManager.game_speed))
	behavior_timer.start()


func _on_teleport_timer_timeout():
	position = Vector2(randi_range(0 + 100, 1920 - 100), randi_range(0 + 100, 1080 - 100))
	if GameManager.game_level == 2:
		teleport_timer.set_wait_time(randf_range(3.0/GameManager.game_speed, 8.0/GameManager.game_speed))
		teleport_timer.start()
	elif GameManager.game_level == 3:
		teleport_timer.set_wait_time(randf_range(1.0/GameManager.game_speed, 4.0/GameManager.game_speed))
		teleport_timer.start()
