class_name BossQuiz
extends BaseMicrogame
@export var transition_rect: TextureRect

@export var game_music: AudioStreamPlayer

@export var game_timer: Timer
@export var p1_time_label: Label
@export var p2_time_label: Label
@export var p1_question_label: RichTextLabel
@export var p2_question_label: RichTextLabel
@export var p1_top_label: RichTextLabel
@export var p1_left_label: RichTextLabel
@export var p1_right_label: RichTextLabel
@export var p1_bottom_label: RichTextLabel
@export var p2_top_label: RichTextLabel
@export var p2_left_label: RichTextLabel
@export var p2_right_label: RichTextLabel
@export var p2_bottom_label: RichTextLabel

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
	["[center]What year did the original [i]Super Mario Bros.[/i] release?[/center]", "1985", "", "", "", "1999", "1989", "1995", "1990", "1991", "1982", "1984", "19-Aught-7"],
	["[center]What does \"COGS\" stand for?[/center]", "Creation of Games Society", "", "", "", "Community of Game Scholars", "Conservation of Games Syndicate", "The acronym is meaningless.", "Cost of Goods Sold", "It's the last name of the club's founder.", "Community of Gamedev Specialists", "Console and Online Gaming Society", "Creative Optimization of Games Squad", "Computer Operations and Gaming Simulations", "Cooperative Online Game Studio", "Collaborative Open Game Studio"],
	["[center]What is the name of COGS' special event held once every semester?[/center]", "Scarlet Game Jam", "", "", "", "Scarlet Game Night", "RU Gaming?", "Fireside Open", "Scarlet Classic", "COGS Minecraft Night"],
	["[center]What is the highest grossing arcade game of all time?[/center]", "[i]Pac-Man[/i]", "", "", "", "[i]Space Invaders[/i]", "[i]Street Fighter II[/i]", "[i]NBA Jam[/i]", "[i]Asteroids[/i]", "[i]Mortal Kombat II[/i]", "[i]Donkey Kong[/i]", "[i]Galaga[/i]", "[i]Snake[/i]", "[i]Pong[/i]", "[i]Dig Dug[/i]", "[i]Frogger[/i]", "[i]Centipede[/i]"],
	["[center]What does the \"DS\" in \"Nintendo DS\" stand for?[/center]", "Developers' System", "", "", "", "Digital System", "Digital Screen", "Double Screen", "Display Sync", "Data Sharing", "Dynamic System"],
	["[center]What does the \"DS\" in \"Nintendo DS\" stand for?[/center]", "Dual Screen", "", "", "", "Digital System", "Digital Screen", "Double Screen", "Display Sync", "Data Sharing", "Dynamic System"],
	["[center]What is the name of Kratos' son in [i]God of War Ragnarök[/i]?[/center]", "Atreus", "", "", "", "Babitos", "Kratos never cared to name him, and just calls him \"boy\".", "Agamemnon", "Menelaus", "Pallas", "Potestas", "Baldur", "Belial", "Asmodeus", "Atriox", "Artemis", "Apollo"],
	["[center]What is today's date?[/center]"]
	]
var current_correct_answer_p1 = 0
var current_correct_answer_p2 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.p1_just_failed = true
	GameManager.p2_just_failed = true
	
	if GameManager.game_level == 1:
		craft_date_question()
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
	
	var question_list
	if GameManager.game_level == 1:
		question_list = question_list_easy
	elif GameManager.game_level == 2:
		pass
	elif GameManager.game_level == 3:
		pass
	
	var asked = []
	
	var current_question_num_p1 = randi_range(0, question_list.size() - 1)
	while current_question_num_p1 in asked:
		current_question_num_p1 = randi_range(0, question_list.size() - 1)
	asked.append(current_question_num_p1)
	if question_list == question_list_easy && (current_question_num_p1 == 5 || current_question_num_p1 == 6):
		asked.append(5)
		asked.append(6)
		
	
	var current_question_num_p2 = randi_range(0, question_list.size() - 1)
	while current_question_num_p2 in asked:
		current_question_num_p2 = randi_range(0, question_list.size() - 1)
	asked.append(current_question_num_p2)
	if question_list == question_list_easy && (current_question_num_p2 == 5 || current_question_num_p2 == 6):
		asked.append(5)
		asked.append(6)
	
	print(asked)
	
	print(question_list[current_question_num_p1])
	print(question_list[current_question_num_p2])
	generate_question_p1(question_list[current_question_num_p1])
	generate_question_p2(question_list[current_question_num_p2])
	


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
		p1_top_label.text = "[center]" + question.pop_front() + "[/center]"
	elif current_correct_answer_p1 == 2:
		p1_left_label.text = "[center]" + question.pop_front() + "[/center]"
	elif current_correct_answer_p1 == 3:
		p1_right_label.text = "[center]" + question.pop_front() + "[/center]"
	else:
		p1_bottom_label.text = "[center]" + question.pop_front() + "[/center]"
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
				p1_top_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			elif next_spot_to_put_in == 2:
				p1_left_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			elif next_spot_to_put_in == 3:
				p1_right_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			else:
				p1_bottom_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			answers_placed += 1
			
	#fill in remainder with randy options
	while answers_placed < 4:
		next_answer_to_put_in = question.pop_at(randi_range(0, question.size() - 1))
		next_spot_to_put_in = randi_range(1, 4)
		while already_used.has(next_spot_to_put_in):
			next_spot_to_put_in = randi_range(1, 4)
		already_used.append(next_spot_to_put_in)
		if next_spot_to_put_in == 1:
			p1_top_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		elif next_spot_to_put_in == 2:
			p1_left_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		elif next_spot_to_put_in == 3:
			p1_right_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		else:
			p1_bottom_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		answers_placed += 1
		
func generate_question_p2(question):
	#Pop the question and display
	p2_question_label.text = question.pop_front()
	
	#Generate a number for the location of the answer and place it somewhere random, appending that random spot to already used
	current_correct_answer_p2 = randi_range(1, 4)
	var already_used = []
	var answers_placed = 0
	already_used.append(current_correct_answer_p2)
	if current_correct_answer_p2 == 1:
		p2_top_label.text = "[center]" + question.pop_front() + "[/center]"
	elif current_correct_answer_p2 == 2:
		p2_left_label.text = "[center]" + question.pop_front() + "[/center]"
	elif current_correct_answer_p2 == 3:
		p2_right_label.text = "[center]" + question.pop_front() + "[/center]"
	else:
		p2_bottom_label.text = "[center]" + question.pop_front() + "[/center]"
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
				p2_top_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			elif next_spot_to_put_in == 2:
				p2_left_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			elif next_spot_to_put_in == 3:
				p2_right_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			else:
				p2_bottom_label.text = "[center]" + next_answer_to_put_in + "[/center]"
			answers_placed += 1
			
	#fill in remainder with randy options
	while answers_placed < 4:
		next_answer_to_put_in = question.pop_at(randi_range(0, question.size() - 1))
		next_spot_to_put_in = randi_range(1, 4)
		while already_used.has(next_spot_to_put_in):
			next_spot_to_put_in = randi_range(1, 4)
		already_used.append(next_spot_to_put_in)
		if next_spot_to_put_in == 1:
			p2_top_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		elif next_spot_to_put_in == 2:
			p2_left_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		elif next_spot_to_put_in == 3:
			p2_right_label.text = "[center]" + next_answer_to_put_in + "[/center]"
		else:
			p2_bottom_label.text = "[center]" + next_answer_to_put_in + "[/center]"
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
	
func craft_date_question():
	var date = Time.get_date_dict_from_system(false)
	var year = int(date.year)
	var month = int(date.month)
	var day = int(date.day)
	question_list_easy[8].append(str(month) + "/" + str(day) + "/" + str(year))
	for i in range(0, 3):
		question_list_easy[8].append("")
	
	question_list_easy[8].append(str(day) + "/" + str(month) + "/" + str(year))
	question_list_easy[8].append(str(month + 1) + "/" + str(day) + "/" + str(year))
	question_list_easy[8].append(str(month - 1) + "/" + str(day) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day + 1) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day + 2) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day + 3) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day - 1) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day - 2) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day - 3) + "/" + str(year))
	question_list_easy[8].append(str(month) + "/" + str(day) + "/" + str(year + 1))
	question_list_easy[8].append(str(month) + "/" + str(day) + "/" + str(year - 1))
	question_list_easy[8].append(str(month) + "/" + str(day + 1) + "/" + str(year + 1))
	question_list_easy[8].append(str(month) + "/" + str(day + 1) + "/" + str(year - 1))
	question_list_easy[8].append(str(month) + "/" + str(day - 1) + "/" + str(year + 1))
	question_list_easy[8].append(str(month) + "/" + str(day - 1) + "/" + str(year - 1))
	question_list_easy[8].append(str(month + 1) + "/" + str(day + 1) + "/" + str(year))
	question_list_easy[8].append(str(month - 1) + "/" + str(day + 1) + "/" + str(year))
	question_list_easy[8].append(str(month + 1) + "/" + str(day - 1) + "/" + str(year))
	question_list_easy[8].append(str(month - 1) + "/" + str(day - 1) + "/" + str(year))
