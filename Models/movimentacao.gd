extends CharacterBody3D

@export var speed = 7.0

func _physics_process(delta):
	var direction = Vector3.ZERO

	# Movimentação básica (frente, trás, esquerda, direita)
	if Input.is_action_pressed("direita"):
		direction -= transform.basis.z
	if Input.is_action_pressed("esquerda"):
		direction += transform.basis.z
	if Input.is_action_pressed("frente"):
		direction -= transform.basis.x
	if Input.is_action_pressed("tras"):
		direction += transform.basis.x
	if Input.is_action_pressed("cima"):
		direction += Vector3.UP
	if Input.is_action_pressed("baixo"):
		direction -= Vector3.UP

	# Define a velocidade e move o corpo
	velocity = direction.normalized() * speed
	move_and_slide()
