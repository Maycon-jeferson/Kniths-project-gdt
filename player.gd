extends CharacterBody2D
# === CONFIGURAÇÕES DO PERSONAGEM ===
var gravity: float = 5.0                  # Gravidade aplicada quando no ar
var move_speed: float = 150.0            # Velocidade de movimento lateral
var jump_force: float = -180.0           # Força aplicada no pulo
var jump_time_max: float = 0.3           # Duração máxima do pulo "sustentado"
var jump_timer: float = 0.0              # Temporizador do pulo
var air_jump_move_speed:float = 120

# === ESTADOS DO PERSONAGEM ===
var is_jumping: bool = false             # Indica se está em um pulo sustentado
var is_taking_damage: bool = false       # Indica se o jogador sofreu dano
var is_dead: bool = false                # Indica se o jogador morreu

func _process(delta: float) -> void:
	# Se o jogador estiver sofrendo dano, executa animação de morte e pausa o resto
	if is_taking_damage:
		handle_damage()
		return #retorna a funcao e pausa o jogo

	# === FÍSICA DO PULO E QUEDA ===
	if not is_on_floor():
		# Aplica gravidade continuamente enquanto estiver no ar
		velocity.y += gravity

	# Início do pulo
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		is_jumping = true
		jump_timer = 0.0
		velocity.y = jump_force  # Começa o pulo com a força inicial

	# Pulo sustentado (enquanto segura o botão e dentro do tempo limite)
	if Input.is_action_pressed("ui_up") and is_jumping:
		jump_timer += delta
		if jump_timer < jump_time_max:
			velocity.y = jump_force
		else:
			is_jumping = false

	# Quando o botão de pulo é solto, encerra o pulo sustentado
	if Input.is_action_just_released("ui_up"):
		is_jumping = false
		

	# === MOVIMENTO LATERAL ===
	if Input.is_action_pressed("ui_right"):
		velocity.x = move_speed if is_on_floor() else air_jump_move_speed
		$AnimatedSprite2D.flip_h = false  # Vira o sprite para a direita

	elif Input.is_action_pressed("ui_left"):
		velocity.x = -move_speed if is_on_floor() else - (air_jump_move_speed)
		$AnimatedSprite2D.flip_h = true   # Vira o sprite para a esquerda

	else:
		velocity.x = 0  # Para o movimento horizontal

	# Simulação de dano ao apertar "para baixo"
	if Input.is_action_just_pressed("ui_down"):
		is_taking_damage = true

	# Aplica movimento com colisão
	move_and_slide()

	# Atualiza a animação conforme o movimento
	update_animation()

# === ATUALIZA ANIMAÇÃO COM BASE NA VELOCIDADE ===
func update_animation() -> void:
	if velocity.x != 0:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")

# === EXECUTA A ANIMAÇÃO DE DANO/MORTE E RECARREGA A FASE ===
func handle_damage() -> void:
	if is_dead:
		return

	$AnimatedSprite2D.play("Death")
	print("Jogador atingido!")
	is_dead = true

	# Aguarda 1 segundo e reinicia a cena
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
