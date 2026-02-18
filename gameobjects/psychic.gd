extends CharacterBody2D

const WALK_ANIM = "go_"

@export var walk_speed: float = 100.0
@export var enter_direction: Vector2 = Vector2.DOWN

## Font used to display debug text.
var debug_font = preload("uid://crk02q7wwi7ou")
## Player look direction angle.
var current_look_angle: float
var direction: Vector2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
@onready var ray_launcher: Node2D = $RayLauncher

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Default animation look to south.
	#animation_player.stop()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use_power"):
		# TODO: lanzar un rayo electrico psíquico.
		print("animacion rayo")
		$AnimationPlayer.play("throw_ray")


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	var direction_norm = direction.normalized()
	
	if direction.length() > 0:
		current_look_angle = direction.angle()
	ray_launcher.rotation = current_look_angle
	
	# Apply movement to character.
	velocity = direction_norm * walk_speed
	
	# Update AnimationTree state for animating player sprite.
	update_blend(direction_norm)
	movement()
	move_and_slide()


func _draw() -> void:
	pass


func _input(event: InputEvent) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	pass


func update_blend(value) -> void:
	if value == Vector2.ZERO:
		return
	
	value.y *= -1
	animation_tree.set("parameters/walk/blend_position", value)
	animation_tree.set("parameters/idle/blend_position", value)


func movement() -> void:
	if is_zero_approx(velocity.length()):
		state_machine.travel("idle")
	else:
		state_machine.travel("walk")

func _on_animation_player_current_animation_changed(name: StringName) -> void:
	pass
