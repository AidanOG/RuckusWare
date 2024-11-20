extends Node
@export var transition_rect: TextureRect

@export var game_timer: Timer
@export var tick_timer_1: Timer
@export var tick_timer_2: Timer
@export var tick_timer_3: Timer
@export var early_finish_timer_1: Timer
@export var early_finish_timer_2: Timer
@export var early_finish_timer_3: Timer
@export var game_music: AudioStreamPlayer
@export var tick: AudioStreamPlayer
@export var timer_bar: ProgressBar

@export var bug_scene: PackedScene
#@export var the_whole_microgame: Node

var done_1 = false
var done_2 = false

var num_swatted_1 = 0
var num_swatted_2 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.p1_just_failed = true
	GameManager.p2_just_failed = true
	
	timer_bar.max_value = 7.5/GameManager.game_speed
	timer_bar.min_value = 0
	timer_bar.value = 7.5
	
	for i in range(0,3):
		var bug = bug_scene.instantiate()
		bug.position = Vector2(randi_range(0 + 100, 1920/2 - 100), randi_range(0 + 100, 1080 - 100))
		#bug.position = Vector2(randi_range(500, 550), randi_range(500, 550))
		print(bug.position)
		add_child(bug)
	for i in range(0, 3):
		var bug = bug_scene.instantiate()
		bug.position = Vector2(randi_range(1920/2 + 100, 1920 - 100), randi_range(0 + 100, 1080 - 100))
		#bug.position = Vector2(randi_range(500, 550), randi_range(500, 550))
		print(bug.position)
		add_child(bug)
	
	get_tree().paused = true
	
	if GameManager.game_level == 1:
		pass
	elif GameManager.game_level == 2:
		pass
	elif GameManager.game_level == 3:
		pass
	
	#await get_tree().create_timer(0.125 / GameManager.game_speed).timeout
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(10, 10), (0.5 / GameManager.game_speed))
	# transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), 1)
	await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
	get_tree().paused = false
	
	game_music.set_pitch_scale(GameManager.game_speed)
	game_music.play()
	
	game_timer.set_wait_time(7.5/ GameManager.game_speed)
	early_finish_timer_1.set_wait_time((7.5 - 6.5)/ GameManager.game_speed)
	early_finish_timer_2.set_wait_time((7.5 - 4.5)/ GameManager.game_speed)
	early_finish_timer_3.set_wait_time((7.5 - 2.5)/ GameManager.game_speed)
	tick_timer_1.set_wait_time((7.5 - 0.5)/GameManager.game_speed)
	tick_timer_2.set_wait_time((7.5 - 1.0)/GameManager.game_speed)
	tick_timer_3.set_wait_time((7.5 - 1.5)/GameManager.game_speed)
	
	tick_timer_1.start()
	tick_timer_2.start()
	tick_timer_3.start()
	game_timer.start()
	early_finish_timer_1.start()
	early_finish_timer_2.start()
	early_finish_timer_3.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer_bar.value = game_timer.get_time_left()


func _on_tick_timer_1_timeout():
	print("tick")
	tick.play()


func _on_tick_timer_2_timeout():
	print("tick")
	tick.play()


func _on_t_ick_timer_3_timeout():
	print("tick")
	tick.play()


func _on_early_finish_1_timeout():
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
		early_finish_timer_2.stop()
		#await get_tree().create_timer(0.25/ GameManager.game_speed).timeout
		game_timer.set_wait_time(0.5/ GameManager.game_speed)
		game_timer.start()


func _on_early_finish_3_timeout():
	print("testing for early finish")
	if done_1 == true && done_2 == true:
		print("skip!")
		early_finish_timer_2.stop()
		#await get_tree().create_timer(0.25/ GameManager.game_speed).timeout
		game_timer.set_wait_time(0.5/ GameManager.game_speed)
		game_timer.start()


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
	
	get_tree().change_scene_to_packed(SceneManager.main_scene)


func _on_swatter_1_splat_1():
	num_swatted_1 += 1
	if num_swatted_1 >= 3:
		done_1 = true
		GameManager.p1_just_failed = false


func _on_swatter_2_splat_2():
	num_swatted_2 += 1
	if num_swatted_2 >= 3:
		done_2 = true
		GameManager.p2_just_failed = false
