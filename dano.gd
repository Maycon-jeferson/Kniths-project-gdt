extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.colision_demege = true
			
