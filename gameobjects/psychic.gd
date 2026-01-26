extends CharacterBody2D

@export var walk_speed: float = 100.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Las animaciones de moverse también se usan cuando el jugador está quieto.
	animation_player.stop();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	print(direction)
	
	if direction.length() > 0.0:
		if not animation_player.is_playing():
			animation_player.play("go_down")
	else:
		animation_player.stop()
	
	velocity = direction * walk_speed 
	move_and_slide()

func _input(event: InputEvent) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	pass
