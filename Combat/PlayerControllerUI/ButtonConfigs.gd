extends Button

export(String, "LEFT", "RIGHT", "TOP", "BOTTOM", "ALL") var target = "LEFT"
export var energy_price : int = 2

signal button_attack_pressed(target)

func _ready() -> void:
	show_energy_price()

func _on_Button_pressed() -> void:
	emit_signal("button_attack_pressed", target, energy_price)

func show_energy_price() -> void:
	$EnergyPrice.text = str(energy_price)
	$EnergyPrice.hint_tooltip = "Cost of energy to made this action"
	
