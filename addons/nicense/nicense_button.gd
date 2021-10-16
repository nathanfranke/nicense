tool
extends Button

var window := preload("res://addons/nicense/nicense_window.gd").new()

func _init():
	add_child(window)
	
	if text.empty():
		text = "Show Copyright"

func _pressed() -> void:
	window.popup_centered_clamped(Vector2(800.0, 600.0))
