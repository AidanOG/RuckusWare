extends Node

@export_group("Dependencies")
@export var countdown_timer: Timer
@export var intermission_music_timer: Timer
@export var speed_up_music_timer: Timer
@export var level_up_music_timer: Timer
@export var boss_music_timer: Timer
@export var special_speed_up_music_timer: Timer
@export var intro_timer: Timer
@export var game_over_timer: Timer
@export var intermission_label: Label
@export var countdown_label: Label
@export var p1_lives_label: Label
@export var p2_lives_label: Label
@export var round_count_label: Label
@export var win_music: AudioStreamPlayer
@export var neutral_music: AudioStreamPlayer
@export var lose_music: AudioStreamPlayer
@export var speed_up_music: AudioStreamPlayer
@export var left_racoon: AnimatedSprite2D
@export var right_racoon: AnimatedSprite2D
@export var background_animation: AnimatedSprite2D
@export var heart_1: AnimatedSprite2D
@export var heart_2: AnimatedSprite2D
@export var heart_3: AnimatedSprite2D
@export var heart_4: AnimatedSprite2D
@export var heart_5: AnimatedSprite2D
@export var heart_6: AnimatedSprite2D
@export var heart_7: AnimatedSprite2D
@export var heart_8: AnimatedSprite2D

@export var beat_timer: Timer
@export var heart_1_animation: AnimationPlayer
@export var heart_2_animation: AnimationPlayer
@export var heart_3_animation: AnimationPlayer
@export var heart_4_animation: AnimationPlayer
@export var heart_5_animation: AnimationPlayer
@export var heart_6_animation: AnimationPlayer
@export var heart_7_animation: AnimationPlayer
@export var heart_8_animation: AnimationPlayer

@export var game_grab_stick: PackedScene
@export var game_not_a_bug: PackedScene

@export var boss_quiz: PackedScene

@export var game_scene_container: Node
var current_microgame: BaseMicrogame

var next_game = 0
var speed_up_factor = 2.0 ** (1.0/12.0)



# Called when the node enters the scene tree for the first time.
func _ready():
	
	if GameManager.round_count == 0:
		intro()
	else:
		intermission()
	#intermission()
	current_microgame = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	countdown_label.text = str(floor(countdown_timer.get_time_left()) + 1)

func intro():
	await get_tree().create_timer(0.0/ GameManager.game_speed).timeout
	intro_timer.start()
	intro_timer.set_wait_time(2.0/GameManager.game_speed)
	background_animation.set_speed_scale(GameManager.game_speed)
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	heart_speed_scales()
	
	left_racoon.play("intermission")
	right_racoon.play("intermission")
	beat_timer.set_wait_time(0.5/GameManager.game_speed)
	beat_timer.start()
	pulse_hearts()
	background_animation.play()
	win_music.play() #CHANGE
	lose_music.set_pitch_scale(GameManager.game_speed)
	
	

func intermission():
	if GameManager.p1_just_failed == true:
		if GameManager.p2_just_failed == true && GameManager.p1_lives == 1 && GameManager.p2_lives == 1:
			#"SUDDEN DEATH" logic
			pass
		else:
			GameManager.p1_lives -= 1
			if GameManager.p1_lives == 3:
				heart_1.play("break")
				heart_1_animation.play("blink")
			elif GameManager.p1_lives == 2:
				heart_2.play("break")
				heart_2_animation.play("blink")
			elif GameManager.p1_lives == 1:
				heart_3.play("break")
				heart_3_animation.play("blink")
			elif GameManager.p1_lives == 0:
				heart_4.play("break")
				heart_4_animation.play("blink")
	if GameManager.p2_just_failed == true:
		if GameManager.p1_just_failed == true && GameManager.p1_lives == 1 && GameManager.p2_lives == 1:
			#"SUDDEN DEATH" logic
			pass
		else:
			GameManager.p2_lives -= 1
			if GameManager.p2_lives == 3:
				heart_5.play("break")
				heart_5_animation.play("blink")
			elif GameManager.p2_lives == 2:
				heart_6.play("break")
				heart_6_animation.play("blink")
			elif GameManager.p2_lives == 1:
				heart_7.play("break")
				heart_7_animation.play("blink")
			elif GameManager.p2_lives == 0:
				heart_8.play("break")
				heart_8_animation.play("blink")
	
	if GameManager.p1_lives > 0 && GameManager.p2_lives > 0:
		GameManager.round_count += 1
	
	p1_lives_label.text = str(GameManager.p1_lives)
	p1_lives_label.show()
	p2_lives_label.text = str(GameManager.p2_lives)
	p2_lives_label.show()
	round_count_label.text = str(GameManager.round_count)
	round_count_label.show()
	
	print(GameManager.p1_just_failed)
	print(GameManager.p2_just_failed)
	
	if GameManager.round_count % 14 == 6 || GameManager.round_count % 14 == 11:
	#if GameManager.round_count % 2 == 1:
		GameManager.speed_up_now = true
	elif GameManager.round_count % 14 == 0 && GameManager.round_count != 0:
		GameManager.boss_now = true
		
	
	win_music.set_pitch_scale(GameManager.game_speed)
	lose_music.set_pitch_scale(GameManager.game_speed)
	neutral_music.set_pitch_scale(GameManager.game_speed)
	background_animation.set_speed_scale(GameManager.game_speed)
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	heart_speed_scales()
	
	if GameManager.round_count > 1:
		
		if GameManager.p1_just_failed == false && GameManager.p2_just_failed == false:
			win_music.play()
			left_racoon.play("win")
			right_racoon.play("win")
			
		elif GameManager.p1_just_failed == true && GameManager.p2_just_failed == true:
			lose_music.play()
			left_racoon.play("lose")
			right_racoon.play("lose")
		else:
			neutral_music.play()
			if GameManager.p1_just_failed == false && GameManager.p2_just_failed == true:
				left_racoon.play("win")
				right_racoon.play("lose")
			elif GameManager.p1_just_failed == true && GameManager.p2_just_failed == false:
				left_racoon.play("lose")
				right_racoon.play("win")
		
		if GameManager.special_speed_up_now == true && GameManager.p1_lives > 0 && GameManager.p2_lives > 0:									#used to be 1.375
			countdown_timer.set_wait_time((2.00) / (GameManager.game_speed) + ((4.00 + 1.5) / (GameManager.game_speed * speed_up_factor * speed_up_factor)))
			intermission_music_timer.set_wait_time((2.00)/ (GameManager.game_speed) + (4.00 / (GameManager.game_speed * speed_up_factor * speed_up_factor)))
			special_speed_up_music_timer.set_wait_time((2.00)/ GameManager.game_speed)
			special_speed_up_music_timer.start()
			GameManager.special_speed_up_now = false
			print(GameManager.round_count)
			print("Back up to speed!")
		
		elif GameManager.speed_up_now == true && GameManager.p1_lives > 0 && GameManager.p2_lives > 0:									#used to be 1.375
			countdown_timer.set_wait_time((2.00) / (GameManager.game_speed) + ((4.00 + 1.5) / (GameManager.game_speed * speed_up_factor))) # each part of song is 2sec. 1.375 sec of the intermission is played here, the other 0.625 sec is played in the game scene
			intermission_music_timer.set_wait_time((2.00)/ (GameManager.game_speed) + (4.00 / (GameManager.game_speed * speed_up_factor)))
			speed_up_music_timer.set_wait_time((2.00)/ GameManager.game_speed)
			speed_up_music_timer.start()
			GameManager.speed_up_now = false
			print(GameManager.round_count)
			print("speed!")
			
		elif GameManager.level_up_now == true && GameManager.p1_lives > 0 && GameManager.p2_lives > 0:
			countdown_timer.set_wait_time((2.00) / (GameManager.game_speed) + ((4.00 + 1.5) / (GameManager.game_speed)))
			intermission_music_timer.set_wait_time((2.00)/ (GameManager.game_speed) + (4.00 / (GameManager.game_speed)))
			level_up_music_timer.set_wait_time((2.00)/ GameManager.game_speed)
			level_up_music_timer.start()
			GameManager.level_up_now = false
			print(GameManager.round_count)
			print("Time to level up!")
			
		elif GameManager.boss_now == true && GameManager.p1_lives > 0 && GameManager.p2_lives > 0:
			if GameManager.round_count == 14 || GameManager.round_count == 28:
				countdown_timer.set_wait_time((2.00) / (GameManager.game_speed) + ((4.00 + 1.5) / (1.0)))
				intermission_music_timer.set_wait_time((2.00)/ (GameManager.game_speed) + (4.00 / (1.0)))
			else:
				countdown_timer.set_wait_time((2.00) / (GameManager.game_speed) + ((4.00 + 1.5) / (GameManager.game_speed / speed_up_factor / speed_up_factor)))
				intermission_music_timer.set_wait_time((2.00)/ (GameManager.game_speed) + (4.00 / (GameManager.game_speed / speed_up_factor / speed_up_factor)))
			boss_music_timer.set_wait_time((2.00)/ GameManager.game_speed)
			boss_music_timer.start()
			#GameManager.boss_now = false
			print(GameManager.round_count)
			print("Boss time!")
		
		elif GameManager.p1_lives > 0 && GameManager.p2_lives > 0:
												# used to be 1.375
			countdown_timer.set_wait_time((2.00 + 1.5)/ GameManager.game_speed)
			intermission_music_timer.set_wait_time((2.00)/ GameManager.game_speed)
		
		else:
			#GAME OVER
			game_over_timer.set_wait_time(2.0/GameManager.game_speed)
			game_over_timer.start()
		
		if GameManager.p1_lives > 0 && GameManager.p2_lives > 0:
			intermission_music_timer.start()
		
	else:
		GameManager.intermission_music.play()
		left_racoon.play("intermission")
		right_racoon.play("intermission")
		beat_timer.set_wait_time(0.5/GameManager.game_speed)
		beat_timer.start()
		pulse_hearts()
			
	countdown_label.show()
	countdown_timer.start()
	
	background_animation.play()


func _on_countdown_timer_timeout():
	# GameManager.transition_img = get_viewport().get_texture().get_image()
	# GameManager.transition_tex = ImageTexture.create_from_image(GameManager.transition_img)
	GameManager.p1_just_failed = false
	GameManager.p2_just_failed = false
	if GameManager.p1_lives > 0 && GameManager.p2_lives > 0:
		if GameManager.boss_now == true:
			next_game = randi_range(1000, 1000)
			#while next_game == GameManager.prev_boss:
				#next_game = randi_range(1000, 1000)  #free this code when you have more than 1 boss
			#GameManager.prev_boss = next_game
			GameManager.boss_now = false
			if GameManager.round_count == 14 || GameManager.round_count == 28:
				GameManager.level_up_now = true
			else:
				GameManager.special_speed_up_now = true
		else:
			next_game = randi_range(0, 1)
			while next_game == GameManager.prev_microgame:
				next_game = randi_range(0, 1)
			GameManager.prev_microgame = next_game
		
		if(next_game == 0):
			#get_tree().change_scene_to_packed(SceneManager.grab_stick)
			current_microgame = game_grab_stick.instantiate() as BaseMicrogame
			current_microgame.all_done.connect(_on_microgame_finished)
			game_scene_container.add_child(current_microgame)
		elif(next_game == 1):
			#get_tree().change_scene_to_packed(SceneManager.not_a_bug)
			current_microgame = game_not_a_bug.instantiate() as BaseMicrogame
			current_microgame.all_done.connect(_on_microgame_finished)
			game_scene_container.add_child(current_microgame)
			
		elif(next_game == 1000):
			current_microgame = boss_quiz.instantiate() as BaseMicrogame
			current_microgame.all_done.connect(_on_microgame_finished)
			game_scene_container.add_child(current_microgame)
		right_racoon.hide()
		left_racoon.hide()
		background_animation.hide()
		intermission_label.hide()
		countdown_label.hide()
		p1_lives_label.hide()
		p2_lives_label.hide()
		round_count_label.hide()
		heart_1.hide()
		heart_2.hide()
		heart_3.hide()
		heart_4.hide()
		heart_5.hide()
		heart_6.hide()
		heart_7.hide()
		heart_8.hide()

		var out = "Round %d started with Game Speed %f." % [GameManager.round_count, GameManager.game_speed]
		print(out)
			
func _on_microgame_finished():
	current_microgame.queue_free()
	current_microgame = null
	right_racoon.show()
	left_racoon.show()
	background_animation.show()
	intermission_label.show()
	countdown_label.show()
	p1_lives_label.show()
	p2_lives_label.show()
	round_count_label.show()
	show_hearts()
	intermission()


func _on_intermission_music_timer_timeout():
	GameManager.intermission_music.play()
	left_racoon.play("intermission")
	right_racoon.play("intermission")
	beat_timer.set_wait_time(0.5/GameManager.game_speed)
	beat_timer.start()
	pulse_hearts()


func _on_speed_up_music_timer_timeout():
	GameManager.game_speed *= speed_up_factor
	background_animation.set_speed_scale(GameManager.game_speed)
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	heart_speed_scales()
	GameManager.intermission_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.play()
	# change to speed up animation
	left_racoon.play("intermission")
	right_racoon.play("intermission")
	beat_timer.set_wait_time(0.5/GameManager.game_speed)
	beat_timer.start()
	pulse_hearts()


func _on_level_up_music_timer_timeout():
	GameManager.game_level += 1
	#GameManager.game_speed = 1.0
	background_animation.set_speed_scale(GameManager.game_speed)
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	heart_speed_scales()
	GameManager.intermission_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.play() #CHANGE
	# change to speed up animation
	left_racoon.play("intermission")
	right_racoon.play("intermission")
	beat_timer.set_wait_time(0.5/GameManager.game_speed)
	beat_timer.start()
	pulse_hearts()


func _on_boss_music_timer_timeout():
	if GameManager.round_count == 14 || GameManager.round_count == 28:
		GameManager.game_speed = 1.0
		print("RESET GAME SPEED")
	else:
		GameManager.game_speed = (GameManager.game_speed / speed_up_factor) / speed_up_factor
	background_animation.set_speed_scale(GameManager.game_speed)
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	heart_speed_scales()
	GameManager.intermission_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.play() #CHANGE
	# change to speed up animation
	left_racoon.play("intermission")
	right_racoon.play("intermission")
	beat_timer.set_wait_time(0.5/GameManager.game_speed)
	beat_timer.start()
	pulse_hearts()


func _on_special_speed_up_music_timer_timeout():
	GameManager.game_speed *= speed_up_factor * speed_up_factor
	background_animation.set_speed_scale(GameManager.game_speed)
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	heart_speed_scales()
	GameManager.intermission_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.play()
	# change to speed up animation
	left_racoon.play("intermission")
	right_racoon.play("intermission")
	beat_timer.set_wait_time(0.5/GameManager.game_speed)
	beat_timer.start()
	pulse_hearts()


func _on_intro_timer_timeout():
	intermission()

func _on_game_over_timer_timeout():
	GameManager.game_speed = 1.0
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	heart_speed_scales()
	beat_timer.set_wait_time(0.5/GameManager.game_speed)
	beat_timer.start()
	pulse_hearts()
	
	if GameManager.p1_lives > 0:
		left_racoon.play("win")
	else:
		left_racoon.play("lose")
	if GameManager.p2_lives > 0:
		right_racoon.play("win")
	else:
		right_racoon.play("lose")
	#REPLACE WITH END MUSIC
	win_music.set_pitch_scale(GameManager.game_speed)
	win_music.play()

func _on_beat_timer_timeout():
	pulse_hearts()
	#print("beat")

func pulse_hearts():
	if GameManager.p1_lives >= 4:
		heart_1_animation.play("pulse")
		heart_2_animation.play("pulse")
		heart_3_animation.play("pulse")
		heart_4_animation.play("pulse")
	elif GameManager.p1_lives == 3:
		heart_2_animation.play("pulse")
		heart_3_animation.play("pulse")
		heart_4_animation.play("pulse")
	elif GameManager.p1_lives == 2:
		heart_3_animation.play("pulse")
		heart_4_animation.play("pulse")
	elif GameManager.p1_lives == 1:
		heart_4_animation.play("pulse")
	else:
		pass
	if GameManager.p2_lives >= 4:
		heart_5_animation.play("pulse")
		heart_6_animation.play("pulse")
		heart_7_animation.play("pulse")
		heart_8_animation.play("pulse")
	elif GameManager.p2_lives == 3:
		heart_6_animation.play("pulse")
		heart_7_animation.play("pulse")
		heart_8_animation.play("pulse")
	elif GameManager.p2_lives == 2:
		heart_7_animation.play("pulse")
		heart_8_animation.play("pulse")
	elif GameManager.p2_lives == 1:
		heart_8_animation.play("pulse")
	else:
		pass

func heart_speed_scales():
	heart_1.set_speed_scale(GameManager.game_speed)
	heart_1_animation.set_speed_scale(GameManager.game_speed)
	heart_2.set_speed_scale(GameManager.game_speed)
	heart_2_animation.set_speed_scale(GameManager.game_speed)
	heart_3.set_speed_scale(GameManager.game_speed)
	heart_3_animation.set_speed_scale(GameManager.game_speed)
	heart_4.set_speed_scale(GameManager.game_speed)
	heart_4_animation.set_speed_scale(GameManager.game_speed)
	heart_5.set_speed_scale(GameManager.game_speed)
	heart_5_animation.set_speed_scale(GameManager.game_speed)
	heart_6.set_speed_scale(GameManager.game_speed)
	heart_6_animation.set_speed_scale(GameManager.game_speed)
	heart_7.set_speed_scale(GameManager.game_speed)
	heart_7_animation.set_speed_scale(GameManager.game_speed)
	heart_8.set_speed_scale(GameManager.game_speed)
	heart_8_animation.set_speed_scale(GameManager.game_speed)


func _on_heart_1_animation_finished():
	heart_1_animation.stop()
	heart_1.hide()


func _on_heart_2_animation_finished():
	heart_2_animation.stop()
	heart_2.hide()


func _on_heart_3_animation_finished():
	heart_3_animation.stop()
	heart_3.hide()


func _on_heart_4_animation_finished():
	heart_4_animation.stop()
	heart_4.hide()


func _on_heart_5_animation_finished():
	heart_5_animation.stop()
	heart_5.hide()


func _on_heart_6_animation_finished():
	heart_6_animation.stop()
	heart_6.hide()


func _on_heart_7_animation_finished():
	heart_7_animation.stop()
	heart_7.hide()


func _on_heart_8_animation_finished():
	heart_8_animation.stop()
	heart_8.hide()
	
func show_hearts():
	if GameManager.p1_lives >= 4:
		heart_1.show()
		heart_2.show()
		heart_3.show()
		heart_4.show()
	elif GameManager.p1_lives == 3:
		heart_2.show()
		heart_3.show()
		heart_4.show()
	elif GameManager.p1_lives == 2:
		heart_3.show()
		heart_4.show()
	elif GameManager.p1_lives == 1:
		heart_4.show()
	else:
		pass
	
	if GameManager.p2_lives >= 4:
		heart_5.show()
		heart_6.show()
		heart_7.show()
		heart_8.show()
	elif GameManager.p2_lives == 3:
		heart_6.show()
		heart_7.show()
		heart_8.show()
	elif GameManager.p2_lives == 2:
		heart_7.show()
		heart_8.show()
	elif GameManager.p2_lives == 1:
		heart_8.show()
	else:
		pass
