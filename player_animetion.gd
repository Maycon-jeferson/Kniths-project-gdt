extends CharacterBody2D

func _process(_delta):
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("Run")


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
