extends Area2D

signal send_energy(amount: int)

@export var on_color: Color
@export var off_color: Color = Color.WHITE

var charged_value: float = 0
var charged_tween: Tween

#region Built-in methods.
func _ready() -> void:
	charged_tween = get_tree().create_tween()
	$Sprite2D.modulate = off_color


func _process(delta: float) -> void:
	if charged_value > 0:
		_cool_bright()
#endregion

## Set sprite modulate with [member on_color] value.
func _bright() -> void: 
	$Sprite2D.modulate = on_color

## Slowing set sprite modulate value from [member on_color] to [member off_color].
func _cool_bright():
	charged_tween.kill()
	charged_tween = get_tree().create_tween()
	charged_tween.tween_property(self, "charged_value", 0, 3.0)
	$Sprite2D.modulate = lerp(off_color, on_color, charged_value)
	await charged_tween.finished
	charged_tween.kill()


#region Signal methods.
func _on_area_entered(area: Area2D) -> void:
	if area.has_node("PsyCharge"):
		# Get psy-energy, get iluminate.
		_bright()
		charged_value = 1.0
		var energy: int = area.get_node("PsyCharge").get_meta("energy") as int
		print("Cantidad energía PSY: %d" % energy)
		send_energy.emit(energy)
#endregion
