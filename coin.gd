extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.coin_conter += 1
		queue_free()
		print(body.coin_conter)
