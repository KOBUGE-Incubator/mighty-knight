extends KinematicBody2D

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	move(Vector2(0,-10))

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
