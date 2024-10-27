extends Node
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
@export var game_music: AudioStreamPlayer

var catchable_1
var catchable_2
var failed_1 = false
var failed_2 = false
var success_1 = false
var success_2 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# transition_rect.texture = GameManager.transition_tex
	
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
	
	await get_tree().create_timer(0.125 / GameManager.game_speed).timeout
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(3, 3), (0.75 / GameManager.game_speed))
	# transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), 1)
	await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
	get_tree().paused = false
	
	game_music.set_pitch_scale(GameManager.game_speed)
	game_music.play()
	
	catchable_1 = false
	catchable_2 = false
	
	game_timer.set_wait_time(5/ GameManager.game_speed)
	target_timer_1.set_wait_time(randf_range(0.0, (1.5/ GameManager.game_speed)))
	target_timer_1.start()
	target_timer_2.set_wait_time(randf_range(0.0, (1.5/ GameManager.game_speed)))
	target_timer_2.start()
	
	game_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("any_button_0"):
		if catchable_1 == true && failed_1 == false:
			target_1.target_gravity = 0
			target_1.velocity.y = 0
			success_1 = true
			print("p1 success")
		elif catchable_1 == false && success_1 == false:
			failed_1 = true
			print("p1 failure early")
			GameManager.p1_just_failed = true
	
	if Input.is_action_just_pressed("any_button_1"):
		if catchable_2 == true && failed_2 == false:
			target_2.target_gravity = 0
			target_2.velocity.y = 0
			success_2 = true
			print("p2 success")
		elif catchable_2 == false && success_2 == false:
			failed_2 = true
			print('p2 failure early')
			GameManager.p2_just_failed = true


func _on_catcher_1_area_entered(area):
	catchable_1 = true

func _on_catcher_1_area_exited(area):
	if success_1 == false:
		catchable_1 = false
		print("p1 failure late")
		GameManager.p1_just_failed = true


func _on_catcher_2_area_entered(area):
	catchable_2 = true

func _on_catcher_2_area_exited(area):
	if success_2 == false:
		catchable_2 = false
		print("p2 failure late")
		GameManager.p2_just_failed = true


func _on_game_timer_timeout():
	get_tree().paused = true
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), (0.75 / GameManager.game_speed) )
	
	#var audio_tween = get_tree().create_tween()
	#audio_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	#audio_tween.tween_property(game_music, "volume_db", -60, (1/ GameManager.game_speed)) # -80 db is 0 volume
	
	
	await get_tree().create_timer(1/ GameManager.game_speed).timeout
	get_tree().paused = false
	game_music.stop()
	get_tree().change_scene_to_packed(SceneManager.main_scene)
