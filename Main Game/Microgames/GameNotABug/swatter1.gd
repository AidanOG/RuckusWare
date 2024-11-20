extends CharacterBody2D

@export var swat_cooldown_timer: Timer
@export var swat_area: Area2D

var SPEED = 1000.0 * GameManager.game_speed

signal splat_1
var splatted = 0

func _physics_process(delta):
	if swat_cooldown_timer.get_time_left() <= 0:
		
		if Input.is_action_just_pressed("any_button_0"):
			swat_cooldown_timer.wait_time = 0.5/GameManager.game_speed
			swat_cooldown_timer.start()
			var splat_candidates = swat_area.get_overlapping_areas()
			print(splat_candidates)
			
			for i in len(splat_candidates):
				if splatted < 3:
					splatted += 1
					splat_candidates[i].queue_free()
					splat_1.emit()
		
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_vector("move_left_0", "move_right_0", "move_up_0", "move_down_0")
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)

		move_and_slide()
		
