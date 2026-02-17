extends CharacterBody2D

const WALK_ANIM = "go_"

@export var walk_speed: float = 100.0
@export var enter_direction: Vector2 = Vector2.DOWN

## Font used to display debug look regions for SpriteLooker.
var debug_font = preload("uid://crk02q7wwi7ou")
## Player look direction angle.
var current_look_angle: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_looker: SpriteLooker = $SpriteLooker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Default animation look to south.
	animation_player.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	
	if direction.length() > 0.0:
		current_look_angle = direction.angle()
		var anim_used = sprite_looker.get_animation_name_from_input_direction(direction.angle())
		animation_player.play(WALK_ANIM + anim_used)
	else:
		animation_player.stop()
	
	if Input.is_action_just_pressed("use_power"):
		# TODO: lanzar un rayo electrico psíquico.
		print("animacion rayo")
		$AnimationPlayer.play("throw_ray")


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")

	# Decide walking animation for input direction angle.
	#if direction.length() > 0.0:
		#current_look_angle = direction.angle()
		#var anim_used = sprite_looker.get_animation_name_from_input_direction(direction.angle())
		#animation_player.play(WALK_ANIM + anim_used)
	#else:
		#animation_player.stop()

	# Apply movement to character.
	velocity = direction.normalized() * walk_speed
	move_and_slide()


func _draw():
	for i in 8:
		draw_line(Vector2.ZERO, Vector2(200, 0).rotated(PI/8 + i * PI/4), Color.GREEN, 5)
		draw_string(debug_font, Vector2(150, 0).rotated(i * PI/4), str(i), 0, -1, 24, Color.WHITE)
	draw_arc(Vector2.ZERO, 200, 0, 2*PI, 200, Color.RED, 5)


func _input(event: InputEvent) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	pass


func _on_animation_player_current_animation_changed(name: StringName) -> void:
	$AnimationPlayer.play(name)


func _on_sprite_looker_changed_direction(direction: String) -> void:
	print_rich("[color=#a1c7ff]%s[/color]" % direction)
