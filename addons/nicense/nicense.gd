extends Node

class Copyright:
	var holders: Array
	var license: String
	
	func _init(_holders: Array, _license: String):
		holders = _holders
		license = _license

class Product:
	var title: String
	var copyrights: Array
	var text: String
	
	func _init(_title: String, _copyrights: Array):
		title = _title
		copyrights = _copyrights
		text = _create_text()
	
	func _create_text() -> String:
		var sections := []
		sections.push_back(title)
		
		for copyright in copyrights:
			if copyright is Copyright:
				var section := ""
				for holder in copyright.holders:
					section += "Copyright (c) %s\n" % holder
				section += "License: %s\n" % copyright.license
				
				sections.push_back(section.strip_edges())
			elif copyright is String:
				sections.push_back(copyright)
			else:
				assert(false)
		
		return PoolStringArray(sections).join("\n\n")

class License:
	var title: String
	var text: String
	
	func _init(_title: String, _text: String):
		title = _title
		text = _text

signal copyright_changed()

var _is_dirty := false
func _make_dirty() -> void:
	_is_dirty = true
	call_deferred("_update_dirty")

func _update_dirty() -> void:
	if _is_dirty:
		emit_signal("copyright_changed")
		_is_dirty = false

var _custom_products := []
var _custom_licenses := []

var _products := []
var _licenses := []

func add_product(product: Product) -> void:
	_custom_products.push_back(product)
	_make_dirty()

func add_license(license: License) -> void:
	for v in _custom_licenses:
		assert(v.title != license.title, "Custom license already exists.")
	for v in _licenses:
		assert(v.title != license.title, "Built-in license already exists.")
	
	_custom_licenses.push_back(license)
	_make_dirty()

func get_products() -> Array:
	var arr := []
	arr.append_array(_custom_products)
	arr.append_array(_products)
	return arr

func get_licenses() -> Array:
	var arr := []
	arr.append_array(_custom_licenses)
	arr.append_array(_licenses)
	return arr

func _init():
	for item in Engine.get_copyright_info():
		var copyrights := []
		for part in item.parts:
			copyrights.push_back(Copyright.new(
				part.copyright,
				part.license
			))
		_products.push_back(Product.new(item.name, copyrights))
	
	for item in Engine.get_license_info():
		_licenses.push_back(License.new(item, Engine.get_license_info()[item]))

func _copyright_print(title: String, text: String) -> void:
	print(title, ":")
	
	# Indent text
	text = "\t" + text.replace("\n", "\n\t")
	print(text)
	
	print("\n\n")

func _ready() -> void:
	print("Run with '--copyright' for copyright information.")
	
	if "--copyright" in OS.get_cmdline_args():
		print("{0} BEGIN COPYRIGHT {0}\n\n\n".format(["-".repeat(20)]))
		
		for item in get_products():
			_copyright_print(item.title, item.text)
		
		print("{0} BEGIN LICENSES {0}\n\n\n".format(["-".repeat(20)]))
		
		for item in get_licenses():
			_copyright_print(item.title, item.text)
		
		# Exit as silently as possible.
		Engine.print_error_messages = false
		ProjectSettings.set("debug/settings/stdout/print_fps", false)
		get_tree().quit()
