extends Node

@export var transition_rect: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	# transition_rect.texture = GameManager.transition_tex
	await get_tree().create_timer(1.0).timeout
	var transition_tween = get_tree().create_tween()
	transition_tween.tween_property(transition_rect, "scale", Vector2(3, 3), 1)
	# transition_tween.tween_property(transition_rect, "scale", Vector2(1, 1), 1)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
