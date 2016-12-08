extends KinematicBody2D

onready var check_mid = get_node("check_mid")

func _ready():
	set_fixed_process(true)
	get_node("sprites").set_flip_h(true)

func _fixed_process(delta):
	move(Vector2(-5,0))
	move(Vector2(0,8))
	if check_mid.is_colliding():
		if check_mid.get_collider().is_in_group("tile"):
			queue_free()

func _on_get_player_body_enter( body ):
	if body.get_name() == "knight":
		if body.get_node("sprites/AnimationPlayer").get_current_animation() == "attack":
			get_node("sprites/AnimationPlayer").play("dead")
			get_node("/root/main").add_points(5,get_pos())
			body._on_attack_cooloff_timeout()
		else:
			if not body.shield:
				body.damaged()
		add_collision_exception_with(body)


func _on_AnimationPlayer_finished():
	if get_node("sprites/AnimationPlayer").get_current_animation() == "dead":
		queue_free()
