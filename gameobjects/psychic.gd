extends CharacterBody2D

const ANIM_PREFIX = "go_"

@export var walk_speed: float = 100.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Las animaciones de moverse también se usan cuando el jugador está quieto.
	animation_player.stop();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use_power"):
		print("animacion rayo")
		$AnimationPlayer.play("throw_ray")

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	print(direction)
	
	if direction.length() > 0.0:
		var anim_used = decide_animation(direction)
		
		animation_player.play(anim_used) if anim_used != "idle" else animation_player.stop()
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
		angle = wrapi(int(angle), 0, 8)
		current_animation = ANIM_PREFIX + convert_angle_to_anim_name(angle)
		
	return current_animation

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
'''
func ytal():
	func _process(delta):
    current_animation = "idle"
    var input_dir = Input.get_vector("left", "right", "up", "down")
    if input_dir.length() != 0:
        angle = input_dir.angle() / (PI/4)
        angle = wrapi(int(a), 0, 8)
        current_animation = "run"
    velocity = input_dir * speed
    move_and_slide()
    $AnimatedSprite2D.play(current_animation + str(angle))
'''


func _on_animation_player_current_animation_changed(name: StringName) -> void:
	$AnimationPlayer.play(name)
