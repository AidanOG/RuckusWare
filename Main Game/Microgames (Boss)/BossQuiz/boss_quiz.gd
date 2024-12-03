extends Node

@export var transition_rect: TextureRect
@export var game_music: AudioStreamPlayer


var done_1 = false
var done_2 = false


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
	
	#await get_tree().create_timer(0.125 / GameManager.game_speed).timeout
	var transition_tween = get_tree().create_tween()
	transition_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	transition_tween.tween_property(transition_rect, "scale", Vector2(10, 10), (0.5 / GameManager.game_speed))
	# transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), 1)
	await get_tree().create_timer(0.5/ GameManager.game_speed).timeout
	get_tree().paused = false
	
	game_music.set_pitch_scale(GameManager.game_speed)
	game_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
