extends KinematicBody2D

var danger = true

func _ready():
	set_z(-15)
	set_fixed_process(true)
	
func _fixed_process(delta):
	if not is_colliding():
		move(Vector2(0,10))

func _on_Area2D_body_enter( body ):
	if body.is_in_group("enemy"):
		add_collision_exception_with(body)
	else:
		if body.get_name() == "knight":
			if body.get_node("sprites/AnimationPlayer").get_current_animation() == "attack":
				get_node("/root/main").add_points(8,get_pos())
				body._on_attack_cooloff_timeout()
				queue_free()
			else:
				if danger:
					queue_free()
					body.damaged()


func _on_Area2D_area_enter( area ):
	if area.is_in_group("tile"):
		danger = false
