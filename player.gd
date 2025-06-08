extends CharacterBody2D

# === CONFIGURAÇÕES DO PERSONAGEM ===
var gravity: float = 10.0                # Intensidade da gravidade quando o personagem está no ar
var move_speed: float = 300              # Velocidade de movimento quando está no chão
var jump_force: float = -200.0           # Força inicial do pulo (valor negativo sobe no eixo Y)
var jump_time_max: float = 0.3           # Tempo máximo que o pulo pode ser sustentado
var jump_timer: float = 0.0              # Temporizador para controlar o tempo de pulo sustentado
var air_jump_move_speed: float = 180     # Velocidade de movimento no ar

# === ESTADOS DO PERSONAGEM ===
var is_jumping: bool = false             # Indica se o personagem está realizando um pulo sustentado
var is_taking_damage: bool = false       # Indica se o personagem está sofrendo dano
var is_dead: bool = false                # Indica se o personagem morreu
var coin_conter: float = 0               # Contador de moedas coletadas
var fruit_conter: float = 0              # Contador de frutas coletadas

# Função chamada a cada frame
func _process(delta: float) -> void:

	# Se o personagem estiver sofrendo dano, trata o dano e pausa a execução
	if is_taking_damage:
		handle_damage()
		return # Interrompe o restante do processamento do frame

	# === FÍSICA DO PULO E QUEDA ===
	if not is_on_floor():
		# Aplica gravidade constantemente enquanto estiver no ar
		velocity.y += gravity

	# Início do pulo quando o jogador está no chão e aperta o botão de pulo
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		is_jumping = true
		jump_timer = 0.0
		velocity.y = jump_force  # Aplica força inicial do pulo

	# Enquanto o botão de pulo estiver pressionado e dentro do tempo máximo, mantém o pulo sustentado
	if Input.is_action_pressed("ui_up") and is_jumping:
		jump_timer += delta
		if jump_timer < jump_time_max:
			velocity.y = jump_force + gravity  # Leve ajuste para prolongar o pulo
		else:
			is_jumping = false  # Pulo sustentado termina

	# Quando o botão de pulo é solto, finaliza o pulo sustentado
	if Input.is_action_just_released("ui_up"):
		is_jumping = false

	# === MOVIMENTO LATERAL ===
	if Input.is_action_pressed("ui_right"):
		# Move para a direita com velocidade diferente se estiver no ar
		velocity.x = move_speed if is_on_floor() else air_jump_move_speed
		$AnimatedSprite2D.flip_h = false  # Vira o sprite para a direita

	elif Input.is_action_pressed("ui_left"):
		# Move para a esquerda com velocidade diferente se estiver no ar
		velocity.x = -move_speed if is_on_floor() else -air_jump_move_speed
		$AnimatedSprite2D.flip_h = true   # Vira o sprite para a esquerda

	else:
		# Nenhuma tecla de movimento pressionada → para o movimento lateral
		velocity.x = 0

	# Aplica o movimento e trata colisões
	move_and_slide()

	# Atualiza animações de acordo com o movimento atual
	update_animation()

# === FUNÇÃO DE ANIMAÇÃO ===
# Escolhe qual animação tocar com base na velocidade
func update_animation() -> void:
	if velocity.x != 0:
		$AnimatedSprite2D.play("Run")  # Animação de corrida
	else:
		$AnimatedSprite2D.play("Idle")  # Animação parado

# === TRATAMENTO DE DANO/MORTE ===
# Toca animação de morte e reinicia a cena após 1 segundo
func handle_damage() -> void:
	if is_dead:
		return  # Já está morto, não faz nada

	$AnimatedSprite2D.play("Death")   # Toca animação de morte
	print("Jogador atingido!")        # Mensagem no console (debug)
	is_dead = true                    # Marca como morto

	# Espera 1 segundo e recarrega a cena atual
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
