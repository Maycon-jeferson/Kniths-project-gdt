extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.fruit_conter += 1
		queue_free()
		print(body.fruit_conter)
