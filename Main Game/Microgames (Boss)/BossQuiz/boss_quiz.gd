class_name BossQuiz
extends BaseMicrogame
@export var transition_rect: TextureRect

@export var game_music: AudioStreamPlayer

@export var game_timer: Timer
@export var p1_time_label: Label
@export var p2_time_label: Label
@export var p1_question_label: RichTextLabel
@export var p2_question_label: Label
@export var p1_top_label: Label
@export var p1_left_label: Label
@export var p1_right_label: Label
@export var p1_bottom_label: Label
@export var p2_top_label: Label
@export var p2_left_label: Label
@export var p2_right_label: Label
@export var p2_bottom_label: Label

var questions_answered_1 = 0
var questions_answered_2 = 0
var lives_1 = 3
var lives_2 = 3
var done_1 = false
var done_2 = false
var p1_time
var p2_time

#var current_question_num_p1
var question_list_easy = [
	["[center]Who is Donkey Kong's best friend?[/center]", "Diddy Kong", "Dixie Kong", "", "", "Candy Kong", "Bluster Kong", "Lanky Kong", "Funky Kong", "Chunky Kong", "Lil' Kong", "Stinky Kong", "Mario", "Bowser"],
	["[center]What year did the original [i]Super Mario Bros.[/i] release?[/center]", "1985", "", "", "1999", "1989", "1995", "1990", "1991", "1982", "1984"]
	]
var current_correct_answer_p1 = 0

#question_list_easy.append(["Who is Donkey Kong's best friend?", "Diddy Kong", "Dixie Kong", "", "", "Candy Kong", "Bluster Kong", "Lanky Kong", "Funky Kong", "Chunky Kong"])


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.p1_just_failed = true
	GameManager.p2_just_failed = true
	
	if GameManager.game_level == 1:
		pass
	elif GameManager.game_level == 2:
		pass
	elif GameManager.game_level == 3:
		pass
		
	get_tree().paused = true
	
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(10, 10), (0.5 / GameManager.game_speed))
	await get_tree().create_timer(0.5/GameManager.game_speed).timeout
	get_tree().paused = false
	
	await get_tree().create_timer(2.0/GameManager.game_speed).timeout
	
	game_music.set_pitch_scale(GameManager.game_speed)
	game_music.play()
	
	game_timer.set_wait_time(16/GameManager.game_speed)
	game_timer.start()
	
	#current_question_num_p1 = 0
	print(question_list_easy[0])
	generate_question_p1(question_list_easy[0])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	p1_time = game_timer.get_time_left()
	p1_time_label.text = str("%.2f" % p1_time)
	p2_time = game_timer.get_time_left()
	p2_time_label.text = str("%.2f" % p2_time)

func generate_question_p1(question):
	#Pop the question and display
	p1_question_label.text = question.pop_front()
	
	#Generate a number for the location of the answer and place it somewhere random, appending that random spot to already used
	current_correct_answer_p1 = randi_range(1, 4)
	var already_used = []
	var answers_placed = 0
	already_used.append(current_correct_answer_p1)
	if current_correct_answer_p1 == 1:
		p1_top_label.text = question.pop_front()
	elif current_correct_answer_p1 == 2:
		p1_left_label.text = question.pop_front()
	elif current_correct_answer_p1 == 3:
		p1_right_label.text = question.pop_front()
	else:
		p1_bottom_label.text = question.pop_front()
	answers_placed += 1
	
	#Next, put in the guaranteed fake answers, if there are any
	var next_spot_to_put_in
	var next_answer_to_put_in
	for i in range(0, 3):
		next_answer_to_put_in = question.pop_front()
		if next_answer_to_put_in != "":
			next_spot_to_put_in = randi_range(1, 4)
			while already_used.has(next_spot_to_put_in):
				next_spot_to_put_in = randi_range(1, 4)
			already_used.append(next_spot_to_put_in)
			if next_spot_to_put_in == 1:
				p1_top_label.text = next_answer_to_put_in
			elif next_spot_to_put_in == 2:
				p1_left_label.text = next_answer_to_put_in
			elif next_spot_to_put_in == 3:
				p1_right_label.text = next_answer_to_put_in
			else:
				p1_bottom_label.text = next_answer_to_put_in
			answers_placed += 1
			
	#fill in remainder with randy options
	while answers_placed < 4:
		next_answer_to_put_in = question.pop_at(randi_range(0, question.size() - 1))
		next_spot_to_put_in = randi_range(1, 4)
		while already_used.has(next_spot_to_put_in):
			next_spot_to_put_in = randi_range(1, 4)
		already_used.append(next_spot_to_put_in)
		if next_spot_to_put_in == 1:
			p1_top_label.text = next_answer_to_put_in
		elif next_spot_to_put_in == 2:
			p1_left_label.text = next_answer_to_put_in
		elif next_spot_to_put_in == 3:
			p1_right_label.text = next_answer_to_put_in
		else:
			p1_bottom_label.text = next_answer_to_put_in
		answers_placed += 1


func _on_game_timer_timeout():
	get_tree().paused = true
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), (0.5 / GameManager.game_speed) )

	await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
	get_tree().paused = false
	game_music.stop()
	
	all_done.emit()
