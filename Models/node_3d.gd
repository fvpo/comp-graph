extends Node3D

@onready var porta_esq = $frontdoor_left
@onready var porta_dir = $frontdoor_right

@export var angulo_aberto = 90.0   # grau que a porta abre
@export var velocidade = 2.0       # velocidade de abertura/fechamento

var abrindo = false
var fechado = true
var rot_esq_inicial = Vector3.ZERO
var rot_dir_inicial = Vector3.ZERO

func _ready():
	# salva a rotação inicial das portas
	rot_esq_inicial = porta_esq.rotation_degrees
	rot_dir_inicial = porta_dir.rotation_degrees

func _input(event):
	if event.is_action_pressed("abrir_porta"):
		abrindo = !abrindo

func _process(delta):
	if abrindo:
		# abre portas
		porta_esq.rotation_degrees.y = lerp(porta_esq.rotation_degrees.y, rot_esq_inicial.y + angulo_aberto, delta * velocidade)
		porta_dir.rotation_degrees.y = lerp(porta_dir.rotation_degrees.y, rot_dir_inicial.y - angulo_aberto, delta * velocidade)
	else:
		# fecha portas
		porta_esq.rotation_degrees.y = lerp(porta_esq.rotation_degrees.y, rot_esq_inicial.y, delta * velocidade)
		porta_dir.rotation_degrees.y = lerp(porta_dir.rotation_degrees.y, rot_dir_inicial.y, delta * velocidade)
