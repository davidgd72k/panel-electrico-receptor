extends Area2D

@export var speed: float = 100.0

var shoot_direction: Vector2 = Vector2.ZERO
var shoot_angle: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_direction = Vector2.from_angle(shoot_angle)
	$Sprite2D.rotation = deg_to_rad(rad_to_deg(shoot_angle) + 90) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO: ir hacia adelante.
	position += shoot_direction * speed * delta
