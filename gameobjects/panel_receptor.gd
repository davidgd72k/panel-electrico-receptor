extends Area2D

signal send_energy(amount: float)

@export var on_color: Color
@export var off_color: Color = Color.WHITE
@export var cooldown_time: float = 1.0

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
	# Resetting tween animation.
	charged_tween.kill()
	charged_tween = get_tree().create_tween()
	charged_tween.tween_property(self, "charged_value", 0, cooldown_time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	$Sprite2D.modulate = lerp(off_color, on_color, charged_value)
	await charged_tween.finished
	charged_tween.kill()


#region Signal methods.
func _on_area_entered(area: Area2D) -> void:
	if area.has_node("PsyCharge"):
		# Get psy-energy, get iluminate.
		_bright()
		charged_value = 1.0
		var energy: float = area.get_node("PsyCharge").get_meta("energy") as float
		print("Cantidad energía PSY: %d" % energy)
		send_energy.emit(energy)
		if not area.is_queued_for_deletion():
			area.queue_free()
#endregion
