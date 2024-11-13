extends Node

@export_group("Dependencies")
@export var countdown_timer: Timer
@export var intermission_music_timer: Timer
@export var speed_up_music_timer: Timer
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

var speed_up_addend = 0.06


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.p1_just_failed == true:
		GameManager.p1_lives -= 1
	if GameManager.p2_just_failed == true:
		GameManager.p2_lives -= 1
	
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
	
	if GameManager.round_count % 2 == 0 && GameManager.round_count != 0:
		GameManager.speed_up_now = true
		
	
	win_music.set_pitch_scale(GameManager.game_speed)
	lose_music.set_pitch_scale(GameManager.game_speed)
	neutral_music.set_pitch_scale(GameManager.game_speed)
	background_animation.set_speed_scale(GameManager.game_speed)
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	
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
		
		if GameManager.speed_up_now == true:
			countdown_timer.set_wait_time((2.00) / (GameManager.game_speed) + ((4.00 + 1.375) / (GameManager.game_speed + speed_up_addend))) # each part of song is 2sec. 1.375 sec of the intermission is played here, the other 0.625 sec is played in the game scene
			intermission_music_timer.set_wait_time((2.00)/ (GameManager.game_speed) + (4.00 / (GameManager.game_speed + speed_up_addend)))
			speed_up_music_timer.set_wait_time((2.00)/ GameManager.game_speed)
			speed_up_music_timer.start()
			GameManager.speed_up_now = false
		else:
			countdown_timer.set_wait_time((2.00 + 1.375)/ GameManager.game_speed)
			intermission_music_timer.set_wait_time((2.00)/ GameManager.game_speed)
		
		intermission_music_timer.start()
		
	else:
		GameManager.intermission_music.play()
		left_racoon.play("intermission")
		right_racoon.play("intermission")
			
	countdown_label.show()
	countdown_timer.start()
	
	background_animation.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	countdown_label.text = str(floor(countdown_timer.get_time_left()) + 1)


func _on_countdown_timer_timeout():
	# GameManager.transition_img = get_viewport().get_texture().get_image()
	# GameManager.transition_tex = ImageTexture.create_from_image(GameManager.transition_img)
	GameManager.p1_just_failed = false
	GameManager.p2_just_failed = false
	if GameManager.p1_lives > 0 && GameManager.p2_lives > 0:
		get_tree().change_scene_to_packed(SceneManager.grab_stick)


func _on_intermission_music_timer_timeout():
	GameManager.intermission_music.play()
	left_racoon.play("intermission")
	right_racoon.play("intermission")


func _on_speed_up_music_timer_timeout():
	GameManager.game_speed += speed_up_addend
	background_animation.set_speed_scale(GameManager.game_speed)
	left_racoon.set_speed_scale(GameManager.game_speed)
	right_racoon.set_speed_scale(GameManager.game_speed)
	GameManager.intermission_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.set_pitch_scale(GameManager.game_speed)
	speed_up_music.play()
	left_racoon.play("intermission")
	right_racoon.play("intermission")
