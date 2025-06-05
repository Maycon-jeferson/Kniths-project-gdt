extends CharacterBody2D

var grav = 5
var speed = 150
var jump_force = -200
var jump_time_max = 0.3
var jump_timer = 0.0
var is_jumping = false
var num = 0
var colision_demege = false
var morto = false

func _process(delta):
	#indepede falhas ana animacao de morte
	if colision_demege == true:
		demege_animation()
		return
		
	#pulo e queda
	if !is_on_floor():
		velocity.y += grav
		
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		is_jumping = true
		jump_timer = 0.0
		velocity.y += jump_force
		
	if Input.is_action_pressed("ui_up") and is_jumping:
		jump_timer += delta
		if jump_timer < jump_time_max:
			velocity.y = jump_force
		else:
			is_jumping = false
			
	if Input.is_action_just_released("ui_up"):
		is_jumping = false
	#----------------------------
	
	#Movimento lateral
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		$AnimatedSprite2D.flip_h = false
		
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		$AnimatedSprite2D.flip_h = true
	
	elif  Input.is_action_just_pressed("ui_down"):
		colision_demege = true
	#-----------------------------------
	else:
		velocity.x = 0
	
	
	move_and_slide()
	updade_Animetion()

func updade_Animetion() -> void:
	if velocity.x != 0:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")
	
func demege_animation() ->void:
	if morto == true:
		return
		
	$AnimatedSprite2D.play("Death")
	print("Jogador atingido!")
	morto = true
	
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
