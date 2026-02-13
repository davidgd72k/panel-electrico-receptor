extends Node
class_name SpriteLooker

signal changed_direction(direction: String)
const MAX_FACE_ANGLES: int = 8

@export var directions_names: Dictionary[int, String] = {
	0: "east",
	2: "south",
	4: "west",
	6: "north",
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


static func convert_to_face_angle(input_angle: int) -> int:
	return wrapi(input_angle, 0, MAX_FACE_ANGLES)
