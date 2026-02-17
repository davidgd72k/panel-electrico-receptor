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

## Current look angle in regions range (0 to 7).
var current_face_angle: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set current sprite angle to south.
	current_face_angle = directions_names.keys()[1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(current_face_angle)
	pass


# TODO: método que en base al input recibido del jugador, determina la cara hacia donde debe mirar el sprite.
func get_animation_name_from_input_direction(input_angle: float) -> String:
	# TODO: convierte input_angle (float) en un face_angle (int, con un valor desde 0 al 8).
	var region_face_angle: int = wrap_to_face_angle_regions(input_angle / (PI/4))
	# TODO: en base al face_angle actual (digamos 2, que es hacia abajo) comprobar si el input_angle "encaja" en dicha sección (S) del face_angle (del 3 (OS) al 1 (ES)).
	var look_to_front := _keep_looking_direction_region(region_face_angle, current_face_angle)
	# TODO: si encaja: se obtiene el nombre de la direccion S (que es south) y se envia.
	if look_to_front:
		print_debug("Sigues mirando en la dirección base.")
		return get_direction_name(current_face_angle)
	
	# TODO: si no encajara, se procedera al siguiente algoritmo:
	# TODO: comprobamos si el input_angle encaja con la dirección contraría a la actual (N) con el método de la sección.
	var counter_face_angle = wrap_to_face_angle_regions(current_face_angle + 4)
	# TODO: si encaja: se retorna su nombre (N).
	var look_to_back := _keep_looking_direction_region(region_face_angle, counter_face_angle)
	if look_to_back:
		print_debug("Ahora estás mirando para la dirección contraria.")
		current_face_angle = counter_face_angle
		return get_direction_name(current_face_angle)
		
	# TODO: si no encaja: se comprueba si mira hacia las direcciones restantes (O y E) y se retorna su nombre (que por descarte retornara).
	var left_face_angle = wrap_to_face_angle_regions(current_face_angle - 2)
	var look_to_left: bool = region_face_angle == left_face_angle #_keep_looking_direction_region(region_face_angle, left_face_angle)
	if look_to_left:
		current_face_angle = left_face_angle
		return get_direction_name(left_face_angle)
	
	var right_face_angle = wrap_to_face_angle_regions(current_face_angle + 2)
	var look_to_right : bool = region_face_angle == right_face_angle
	if look_to_right:
		current_face_angle = right_face_angle
		return get_direction_name(right_face_angle)
	
	return "NULL"


func get_direction_name(angle: int) -> String:
	var result: String = ""
	result = directions_names[angle] if directions_names.has(angle) else "NULL"
	
	return result


static func _keep_looking_direction_region(input_face_angle: int, check_face_angle: int) -> bool:
	# Get side angles from current angle.
	var left_angle: int = wrap_to_face_angle_regions(check_face_angle - 1)
	var right_angle: int = wrap_to_face_angle_regions(check_face_angle + 1)
	
	for angle in range(left_angle, right_angle + 1):
		if angle == input_face_angle:
			# You looking to same look region.
			#print_debug("Está en el rango de la sección de mirar.")
			return true
	
	# You don't looking to same look region.
	#print_debug("No está en el rango de la sección de mirar.")
	return false


## Wrap [param input_angle] into the look regions (0 to 7 for example).
static func wrap_to_face_angle_regions(input_angle: int) -> int:
	var wrap_value: int = wrapi(input_angle, 0, MAX_FACE_ANGLES)
	print_debug(wrap_value)
	return wrap_value
