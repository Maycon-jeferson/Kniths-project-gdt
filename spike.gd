extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.is_taking_damage = true
			
