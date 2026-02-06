extends CharacterBody2D

const WALK_ANIM = "go_"

signal stopping_moving

@export var walk_speed: float = 100.0
@export var enter_direction: Vector2 = Vector2.DOWN


var debug_font = preload("uid://crk02q7wwi7ou")
## Last angle face when character is stopped (is -1 when player is moving).
var _stopped_angle_face: int = 0
## Angle when player is moving.
var _moving_angle_face: int = 0

var face_directions: Dictionary[int, String] = {
		0: "right", 
		1: "down-right", 
		2: "down", 
		3: "down-left",
		4: "left", 
		5: "up_left",
		6: "up",
		7: "up-right"
	}

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Las animaciones de moverse también se usan cuando el jugador está quieto.
	var s = decide_face_animation(enter_direction)
	animation_player.play(s)
	animation_player.stop()
	stopping_moving.connect(_on_player_stop_moving)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use_power"):
		# TODO: lanzar un rayo electrico psíquico.
		print("animacion rayo")
		$AnimationPlayer.play("throw_ray")


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")

	# Decide walking animation for input direction angle.
	if direction.length() > 0.0:
		var anim_used = decide_face_animation(direction)
		animation_player.play(anim_used)
	else:
		animation_player.stop()
		# Avoiding call signal too much times.
		if _stopped_angle_face == -1:
			stopping_moving.emit()

	# Apply movement to character.
	velocity = direction.normalized() * walk_speed
	move_and_slide()


func _draw():
	for i in 8:
		draw_line(Vector2.ZERO, Vector2(200, 0).rotated(PI/8 + i * PI/4), Color.GREEN, 5)
		draw_string(debug_font, Vector2(150, 0).rotated(i * PI/4), str(i), 0, -1, 24, Color.WHITE)
	draw_arc(Vector2.ZERO, 200, 0, 2*PI, 200, Color.RED, 5)


func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if Input.is_action_just_pressed("use_power"):
			#$AnimationPlayer.play("throw_ray")
	pass


func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if Input.is_action_just_pressed("use_power"):
			#$AnimationPlayer.play("throw_ray")
	pass

func decide_face_animation(input_dir: Vector2) -> String:
	# "idle" execute AnimationPlayer.stop(), because go_<direction> animations start with idle
	# frame of spritesheet (in each direction).
	var current_animation = "idle"
	var angle: float = 0
	var face_angle: int = 0
	
	# Getting angle from player input.
	angle = input_dir.angle() / (PI/4)
	face_angle = _float_angle_to_int_angle(angle)
	print_rich("[color=red]ANGLE:[/color] %s" %  roundi(angle))
	
	# Convert 
	# TODO: en base a la direccion (face) hacia donde mira el sprite, fijar la face incluso yendo en diagonaol.
	#face_angle = _manage_diagonals_faces(face_angle)
	current_animation = WALK_ANIM + convert_angle_to_anim_name(face_angle)

	return current_animation


func _decide_face_animation_from_stopped(face_angle: int) -> int:
	if _stopped_angle_face != -1:
		# TODO: hace la cosa de decidir cara cuando estás quieto.
		pass
	return -1


func _manage_diagonals_faces(face_angle: int) -> int:
	# TODO: en base a la face actual:
	# TODO: mira hacia abajo: ¿El sector de la diagonal (como 3) es vecina al sector de la cara (2)?
	# TODO: si es el caso: que siga siendo 2.
	# TODO: si es el caso contrario: 
	# TODO: digamos que ahora la direccion (angle) fuera otro número.
	# TODO: si fuera 4 (left), 0 (right) o 6 (up), se retorna esos sectores tal cual.
	# TODO: pero si fuera 5 o 7: se devolvería 6, al ser el contrario de 2 (verticalmente).
	# TODO: aplica igual con 4 y 0, pero en el sentido horizontal.
	var minus_sector: int = face_angle - 1
	var mayor_sector: int = face_angle +1
	for i in range(minus_sector, mayor_sector):
		print(i)
	
	return -1


static func _float_angle_to_int_angle(angle: float) -> int:
	return wrapi(int(angle), 0, 8)

static func convert_angle_to_anim_name(face_angle: int) -> String:
	var anim_name := "down"
	match face_angle:
		0:
			anim_name = "right"
		2:
			anim_name = "down"
		4:
			anim_name = "left"
		6:
			anim_name = "up"

	return anim_name

func _on_player_stop_moving() -> void:
	# TODO: set stopped angle face when player stop moving.
	pass


func _on_animation_player_current_animation_changed(name: StringName) -> void:
	$AnimationPlayer.play(name)
