extends Node
class_name StartScreen

@export_group("Dependencies")
@export var label1: Label
@export var label2: Label
@export var countdown_label: Label
@export var countdown_timer: Timer

var p1_ready_status = false
var p2_ready_status = false
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	label1.text = "Player 1\nPress any face button to get ready!"
	label2.text = "Player 2\nPress any face button to get ready!"
	var controller_IDs = Input.get_connected_joypads()
	if controller_IDs.size() >= 2:
		print(controller_IDs.size())
		print("Controllers ", controller_IDs[0], " & ", controller_IDs[1], " are connected.")
	elif controller_IDs.size() < 2:
		print(controller_IDs.size()) #TODO maybe add the ability to wait until all controllers are plugged in


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("any_button_0"):
		label1.text = "Player 1 ready!"
		p1_ready_status = true
	if Input.is_action_pressed("any_button_1"):
		label2.text = "Player 2 ready!"
		p2_ready_status = true
	if p1_ready_status == true && p2_ready_status == true:
		countdown_label.text = str(floor(countdown_timer.get_time_left()) + 1)
		if game_started == false:
			print("game start")
			countdown_timer.start()
			countdown_label.show()
			game_started = true


func _on_countdown_timer_timeout():
	get_tree().change_scene_to_packed(SceneManager.main_scene)
