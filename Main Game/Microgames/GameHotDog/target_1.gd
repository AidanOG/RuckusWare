extends Area2D

# @export var target_sprite: AnimatedSprite2D
var target_gravity = 0
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += target_gravity * delta
	position += velocity

func _on_visible_on_screen_notifier_2d_child_exiting_tree(node):
	queue_free()


func _on_target_timer_1_timeout():
	target_gravity = (5 * GameManager.game_speed* GameManager.game_speed)
