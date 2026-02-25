extends StaticBody2D

@export var battery_max: float = 100.0
@export var started_battery_charge: float = 0.0
@export var consume_amount: float = 10.0

var current_battery_charge: float
var consume_tween: Tween
var charge_tween: Tween

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var battery_label: Label = $BatteryLabel


# TODO: hacer bombilla que se ilumina al recibir corriente, y pasado un tiempo, se apagué.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charge_tween = get_tree().create_tween()
	consume_tween = get_tree().create_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Show the current charge of lightbulb.
	battery_label.text = str( snappedf(current_battery_charge, 2)) 
	
	# Lightbulb need charge to light.
	sprite_2d.frame = 0 if is_zero_approx(current_battery_charge) or current_battery_charge < 0 else 1


func _consume_battery(amount: float):
	if is_zero_approx(current_battery_charge):
		return
	consume_tween.kill()
	consume_tween = get_tree().create_tween()
	consume_tween.tween_property(self, "current_battery_charge", current_battery_charge - amount, 0.5)
	await consume_tween.finished
	current_battery_charge = clampf(current_battery_charge, 0, battery_max)


func _charge_battery(amount: float):
	charge_tween.kill()
	charge_tween = get_tree().create_tween()
	charge_tween.tween_property(self, "current_battery_charge", current_battery_charge + amount, 0.5)
	await charge_tween.finished
	current_battery_charge = clampf(current_battery_charge, 0, battery_max)


func _on_consume_timer_timeout() -> void:
	# Lightbulb consume energy each timeout.
	_consume_battery(consume_amount)
	


func _on_panel_receptor_send_energy(amount: float) -> void:
	_charge_battery(amount)
	pass # Replace with function body.
