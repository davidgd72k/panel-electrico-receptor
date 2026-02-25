extends Line2D

@export var on_color: Color
@export var off_color: Color
@export var cooldown_time: float = 1.0
var charged_tween: Tween
var charged_value: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charged_tween = get_tree().create_tween()
	self.default_color = off_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if charged_value > 0:
		_cool_bright()


func _bright() -> void: 
	self.default_color = on_color


## Slowing set sprite modulate value from [member on_color] to [member off_color].
func _cool_bright():
	# Resetting tween animation.
	charged_tween.kill()
	charged_tween = get_tree().create_tween()
	charged_tween.tween_property(self, "charged_value", 0, cooldown_time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	self.default_color = lerp(off_color, on_color, charged_value)
	await charged_tween.finished
	charged_tween.kill()

func _on_panel_receptor_send_energy(amount: float) -> void:
	_bright()
	charged_value = 1.0
	pass # Replace with function body.
