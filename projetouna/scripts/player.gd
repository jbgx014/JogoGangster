extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Referência para o nó de animação (supondo que seja um AnimatedSprite2D)
@onready var animated_sprite = $anim

func _physics_process(delta: float) -> void:
	# Adiciona a gravidade ao componente y de velocity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		if animated_sprite.animation != "jump":
			animated_sprite.play("jump")
		print("Personagem está no ar!")

	# Manipula o pulo.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		print("Pulo acionado!")
		velocity.y = JUMP_VELOCITY
		# Altera para a animação de pulo assim que o pulo começar


	# Obtém a direção de entrada e manipula o movimento/desaceleração.
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED

		# Alterna para a animação de "run" quando estiver no chão
		if is_on_floor() and animated_sprite.animation != "run":
			animated_sprite.play("run")

		# Vira o sprite dependendo da direção
		animated_sprite.flip_h = direction < 0
	else:
		# Reduz gradualmente a velocidade a zero
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Alterna para a animação de "idle" quando não há movimento e está no chão
		if is_on_floor() and animated_sprite.animation != "idle":
			animated_sprite.play("idle")

	# Quando o personagem retorna ao chão, volta para a animação "idle" ou "run" dependendo do movimento
	if is_on_floor():
		# Se estava pulando, muda para a animação de "run" ou "idle"
		if animated_sprite.animation == "jump":
			if direction != 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")

	# Move o personagem e aplica a física
	move_and_slide()
