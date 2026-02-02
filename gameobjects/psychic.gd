extends CharacterBody2D

const WALK_ANIM = "go_"

@export var walk_speed: float = 100.0
var font = preload("uid://crk02q7wwi7ou")
var face_stopped: int = 0;
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Las animaciones de moverse también se usan cuando el jugador está quieto.
	var s = decide_animation(Vector2.DOWN)
	animation_player.play(s)
	animation_player.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use_power"):
		print("animacion rayo")
		$AnimationPlayer.play("throw_ray")

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	#print(direction)

	if direction.length() > 0.0:
		var anim_used = decide_animation(direction)

		animation_player.play(anim_used)
	else:
		animation_player.stop()

	velocity = direction.normalized() * walk_speed
	move_and_slide()

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

func decide_animation(input_dir: Vector2) -> String:
	# "idle" execute AnimationPlayer.stop(), because go_<direction> animations start with idle
	# frame of spritesheet (in each direction).
	var current_animation = "idle"
	var angle: float = 0

	if input_dir.length() != 0:
		angle = input_dir.angle() / (PI/4)
		angle = convert_angle_to_dir_num(angle)
		print_rich("[color=red]ANGLE:[/color] %s" %  roundf(angle))
		current_animation = WALK_ANIM + convert_angle_to_anim_name(angle)

	return current_animation

func _draw():
	for i in 8:
		draw_line(Vector2.ZERO, Vector2(200, 0).rotated(PI/8 + i * PI/4), Color.GREEN, 5)
		draw_string(font, Vector2(150, 0).rotated(i * PI/4), str(i), 0, -1, 24, Color.WHITE)
	draw_arc(Vector2.ZERO, 200, 0, 2*PI, 200, Color.RED, 5)


func decide_face() -> int:
	
	return -1

static func convert_angle_to_dir_num(angle: float) -> int:
	return wrapi(int(angle), 0, 8)

static func convert_angle_to_anim_name(angle: float) -> String:
	var anim_name := "down"
	match int(angle):
		0:
			anim_name = "right"
		2:
			anim_name = "down"
		4:
			anim_name = "left"
		6:
			anim_name = "up"

	return anim_name


func _on_animation_player_current_animation_changed(name: StringName) -> void:
	$AnimationPlayer.play(name)
