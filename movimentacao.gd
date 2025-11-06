extends CharacterBody3D

@export var speed = 10.0
@export var mouse_sensitivity = 0.002
@export var vertical_rotation_limit: float = PI / 2.0 # 90 degrees in radians


# Cache camera nodes
@onready var camera_mount = $CameraMount
@onready var camera = $"CameraMount/Camera3D"

var _is_mouse_captured = false
# Called when the node enters the scene tree
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_is_mouse_captured = true

# Handle mouse movement for camera rotation (camera only — character stays static)
func _input(event):
	# Release mouse capture on Escape key press
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_is_mouse_captured = false
		return

	# Capture mouse on left-click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_is_mouse_captured = true

	# Mouse motion: rotate camera only when captured
	if event is InputEventMouseMotion and _is_mouse_captured:
		# Yaw: rotate the CameraMount around the Y axis (keeps character static)
		camera_mount.rotate_y(-event.relative.x * mouse_sensitivity)
		# Pitch: rotate the camera around its local X axis and clamp
		var new_rotation_x = camera.rotation.x - event.relative.y * mouse_sensitivity
		camera.rotation.x = clamp(new_rotation_x, -vertical_rotation_limit, vertical_rotation_limit)
func _physics_process(_delta):
	var direction = Vector3.ZERO

	# Use the camera's forward/right vectors so movement is relative to camera look
	var cam_basis = camera.global_transform.basis
	var cam_forward = -cam_basis.z
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()
	var cam_right = cam_basis.x
	cam_right.y = 0
	cam_right = cam_right.normalized()

	# Movimentação básica (frente, trás, esquerda, direita) relative to camera
	if Input.is_action_pressed("direita"):
		direction += cam_right
	if Input.is_action_pressed("esquerda"):
		direction -= cam_right
	if Input.is_action_pressed("frente"):
		direction += cam_forward
	if Input.is_action_pressed("tras"):
		direction -= cam_forward
	if Input.is_action_pressed("cima"):
		direction += Vector3.UP
	if Input.is_action_pressed("baixo"):
		direction -= Vector3.UP

	# Apply velocity (keep zero velocity when no input)
	if direction != Vector3.ZERO:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector3.ZERO

	move_and_slide()
