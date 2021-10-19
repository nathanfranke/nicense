tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("Nicense", "res://addons/nicense/nicense.gd")
	add_custom_type("NicenseButton", "Button", load("res://addons/nicense/nicense_button.gd"), preload("res://addons/nicense/control.svg"))
	add_custom_type("NicenseWindow", "WindowDialog", load("res://addons/nicense/nicense_window.gd"), preload("res://addons/nicense/control.svg"))

func _exit_tree():
	remove_autoload_singleton("Nicense")
	remove_custom_type("NicenseWindow")
	remove_custom_type("NicenseButton")
