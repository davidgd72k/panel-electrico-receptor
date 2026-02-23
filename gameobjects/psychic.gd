extends CharacterBody2D

const WALK_ANIM = "go_"
const PSY_SHOOT = preload("uid://deny88jv3l3bb")

@export var walk_speed: float = 100.0
@export var enter_direction: Vector2 = Vector2.DOWN
@export var acceleration: float = 10.0
@export var friction: float = 15.0

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
	update_blend(Vector2.DOWN)
	current_look_angle = Vector2.DOWN.angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use_power"):
		shoot_ray()

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	var direction_norm = direction.normalized()
	
	if Input.is_action_pressed("aiming"):
		if direction.length() != 0.0:
			current_look_angle = direction.angle()
		velocity.x = move_toward(velocity.x, 0.0, friction)
		velocity.y = move_toward(velocity.y, 0.0, friction)
	# Moving character.
	elif direction != Vector2.ZERO:
		# Rotate shoot arrow.
		current_look_angle = direction.angle()
		
		velocity.x = move_toward(velocity.x, direction_norm.x * walk_speed, acceleration)
		velocity.y = move_toward(velocity.y, direction_norm.y * walk_speed, acceleration)
		
	# Braking character.
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction)
		velocity.y = move_toward(velocity.y, 0.0, friction)
	
		# Apply update_movement_state to character.
		#velocity = direction_norm * walk_speed
	
	ray_launcher.rotation = current_look_angle
	# Update AnimationTree state for animating player sprite.
	update_blend(direction_norm)
	update_movement_state()
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
	
	# Mirror Y value to match with BlendSpace2D look.
	value.y *= -1
	animation_tree.set("parameters/walk/blend_position", value)
	animation_tree.set("parameters/idle/blend_position", value)


func update_movement_state() -> void:
	if is_zero_approx(velocity.length()):
		state_machine.travel("idle")
	else:
		state_machine.travel("walk")

func shoot_ray() -> void:
	var shoot = PSY_SHOOT.instantiate()
	shoot.shoot_angle = current_look_angle
	var aim_distance = $RayLauncher/Sprite2D.position + Vector2(20,0)
	shoot.global_position = self.global_position + aim_distance.rotated(current_look_angle)
	get_tree().current_scene.add_child(shoot)


func timeShoot(time: float):
	print("Tiempo parado en %d segundos" % time)


func _on_animation_player_current_animation_changed(name: StringName) -> void:
	pass
