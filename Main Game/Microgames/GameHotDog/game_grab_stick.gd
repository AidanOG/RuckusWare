class_name GameGrabStick
extends BaseMicrogame
# 120 BPM = 2 BPS
# 0.5 s = 1 beat
@export var transition_rect: TextureRect
@export var target_1: Area2D
@export var target_2: Area2D
@export var target_1_collision: CollisionShape2D
@export var target_2_collision: CollisionShape2D
@export var catcher_1_collision: CollisionShape2D
@export var catcher_2_collision: CollisionShape2D
@export var target_timer_1: Timer
@export var target_timer_2: Timer
@export var game_timer: Timer
@export var tick_timer_1: Timer
@export var tick_timer_2: Timer
@export var tick_timer_3: Timer
@export var early_finish_timer_0: Timer
@export var early_finish_timer_1: Timer
@export var early_finish_timer_2: Timer
@export var game_music: AudioStreamPlayer
@export var tick: AudioStreamPlayer
@export var timer_bar: ProgressBar

@export var sfx_whip1: AudioStreamPlayer
@export var sfx_whip2: AudioStreamPlayer
@export var sfx_miss1: AudioStreamPlayer
@export var sfx_miss2: AudioStreamPlayer

var catchable_1
var catchable_2
var failed_1 = false
var failed_2 = false
var success_1 = false
var success_2 = false
var done_1 = false
var done_2 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# transition_rect.texture = GameManager.transition_tex
	#GameManager.game_speed = 3.0
	timer_bar.max_value = 7.5/GameManager.game_speed
	timer_bar.min_value = 0
	timer_bar.value = 7.5
	
	get_tree().paused = true
	
	if GameManager.game_level == 1:
		pass
	elif GameManager.game_level == 2:
		target_1_collision.scale = Vector2(6, 12)
		target_2_collision.scale = Vector2(6, 12)
	elif GameManager.game_level == 3:
		target_1_collision.scale = Vector2(6, 6)
		target_2_collision.scale = Vector2(6, 6)
		catcher_1_collision.scale = Vector2(6, 6)
		catcher_2_collision.scale = Vector2(6, 6)
	
	#await get_tree().create_timer(0.125 / GameManager.game_speed).timeout
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(10, 10), (0.5 / GameManager.game_speed))
	# transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), 1)
	await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
	get_tree().paused = false
	
	game_music.set_pitch_scale(GameManager.game_speed)
	game_music.play()
	
	sfx_whip1.set_pitch_scale(GameManager.game_speed)
	sfx_whip2.set_pitch_scale(GameManager.game_speed)
	sfx_miss1.set_pitch_scale(GameManager.game_speed)
	sfx_miss2.set_pitch_scale(GameManager.game_speed)
	
	catchable_1 = false
	catchable_2 = false
	
	game_timer.set_wait_time(7.5/ GameManager.game_speed)
	early_finish_timer_0.set_wait_time((7.5 - 6.5)/ GameManager.game_speed)
	early_finish_timer_1.set_wait_time((7.5 - 4.5)/ GameManager.game_speed)
	early_finish_timer_2.set_wait_time((7.5 - 2.5)/ GameManager.game_speed)
	tick_timer_1.set_wait_time((7.5 - 0.5)/GameManager.game_speed)
	tick_timer_2.set_wait_time((7.5 - 1.0)/GameManager.game_speed)
	tick_timer_3.set_wait_time((7.5 - 1.5)/GameManager.game_speed)
	target_timer_1.set_wait_time(randf_range(0.0, (5.0/ GameManager.game_speed)))
	target_timer_1.start()
	target_timer_2.set_wait_time(randf_range(0.0, (5.0/ GameManager.game_speed)))
	target_timer_2.start()
	
	tick_timer_1.start()
	tick_timer_2.start()
	tick_timer_3.start()
	game_timer.start()
	early_finish_timer_0.start()
	early_finish_timer_1.start()
	early_finish_timer_2.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer_bar.value = game_timer.get_time_left()
	
	if Input.is_action_just_pressed("any_button_0"):
		if catchable_1 == true && failed_1 == false && done_1 == false:
			target_1.target_gravity = 0
			target_1.velocity.y = 0
			success_1 = true
			done_1 = true
			print("p1 success")
			sfx_whip1.play()
		elif catchable_1 == false && success_1 == false:
			if done_1 == false:
				sfx_miss1.play()
			failed_1 = true
			done_1 = true
			print("p1 failure early")
			GameManager.p1_just_failed = true
			
	
	if Input.is_action_just_pressed("any_button_1"):
		if catchable_2 == true && failed_2 == false && done_2 == false:
			target_2.target_gravity = 0
			target_2.velocity.y = 0
			success_2 = true
			done_2 = true
			print("p2 success")
			sfx_whip2.play()
		elif catchable_2 == false && success_2 == false:
			if done_2 == false:
				sfx_miss2.play()
			failed_2 = true
			done_2 = true
			print('p2 failure early')
			GameManager.p2_just_failed = true
			
	


func _on_catcher_1_area_entered(area):
	catchable_1 = true

func _on_catcher_1_area_exited(area):
	if done_1 == false:
		sfx_miss1.play()
	if success_1 == false:
		catchable_1 = false
		print("p1 failure late")
		GameManager.p1_just_failed = true
		done_1 = true


func _on_catcher_2_area_entered(area):
	catchable_2 = true

func _on_catcher_2_area_exited(area):
	if done_2 == false:
		sfx_miss2.play()
	if success_2 == false:
		catchable_2 = false
		print("p2 failure late")
		GameManager.p2_just_failed = true
		done_2 = true


func _on_game_timer_timeout():
	tick.play()
	print("tick")
	get_tree().paused = true
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), (0.5 / GameManager.game_speed) )
	
	#var audio_tween = get_tree().create_tween()
	#audio_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	#audio_tween.tween_property(game_music, "volume_db", -60, (1/ GameManager.game_speed)) # -80 db is 0 volume
	
	await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
	get_tree().paused = false
	game_music.stop()
	
	all_done.emit()
	#get_tree().change_scene_to_packed(SceneManager.main_scene)


func _on_tick_timer_1_timeout():
	print("tick")
	tick.play()


func _on_tick_timer_2_timeout():
	print("tick")
	tick.play()


func _on_tick_timer_3_timeout():
	print("tick")
	tick.play()


func _on_early_finish_timeout():
	print("testing for early finish")
	if done_1 == true && done_2 == true:
		print("skip!")
		early_finish_timer_2.stop()
		#await get_tree().create_timer(0.25/ GameManager.game_speed).timeout
		game_timer.set_wait_time(0.5/ GameManager.game_speed)
		game_timer.start()


func _on_early_finish_2_timeout():
	print("testing for early finish")
	if done_1 == true && done_2 == true:
		print("skip!")
		#await get_tree().create_timer(0.25/ GameManager.game_speed).timeout
		game_timer.set_wait_time(0.5/ GameManager.game_speed)
		game_timer.start()


func _on_early_finish_0_timeout():
	print("testing for early finish")
	if done_1 == true && done_2 == true:
		print("skip!")
		# await get_tree().create_timer(0.25/ GameManager.game_speed).timeout
		game_timer.set_wait_time(0.5/ GameManager.game_speed)
		game_timer.start()
