tool
extends WindowDialog

var main_container := PanelContainer.new()
var primary_tabs := TabContainer.new()
var products := TabContainer.new()
var licenses := TabContainer.new()

func _init() -> void:
	add_child(main_container)
	main_container.add_child(primary_tabs)
	primary_tabs.add_child(products)
	primary_tabs.add_child(licenses)
	
	if window_title.empty():
		window_title = "Copyright"
	resizable = true
	rect_min_size = Vector2(300.0, 200.0)
	
	main_container.set_anchors_and_margins_preset(PRESET_WIDE)
	
	primary_tabs.tab_align = TabContainer.ALIGN_LEFT
	products.tab_align = TabContainer.ALIGN_LEFT
	licenses.tab_align = TabContainer.ALIGN_LEFT
	
	products.name = "Products"
	licenses.name = "Licenses"
	
	var main_style_box := StyleBoxEmpty.new()
	main_style_box.content_margin_top = 16.0
	main_style_box.content_margin_bottom = 16.0
	main_style_box.content_margin_left = 16.0
	main_style_box.content_margin_right = 16.0
	main_container.add_stylebox_override("panel", main_style_box)
	
	var primary_tabs_style_box := StyleBoxEmpty.new()
	primary_tabs_style_box.content_margin_top = 8.0
	primary_tabs.add_stylebox_override("panel", primary_tabs_style_box)
	
	if not Engine.editor_hint:
		var err := Nicense.connect("copyright_changed", self, "_update_copyright")
		assert(err == OK)
		
		_update_copyright()

func _exit_tree() -> void:
	if not Engine.editor_hint:
		Nicense.disconnect("copyright_changed", self, "_update_copyright")

func _update_copyright() -> void:
	for child in products.get_children():
		products.remove_child(child)
		child.queue_free()
	
	for product in Nicense.get_products():
		_add_product(product)
	
	for child in licenses.get_children():
		licenses.remove_child(child)
		child.queue_free()
	
	for license in Nicense.get_licenses():
		_add_license(license)

func _add_product(product: Nicense.Product) -> void:
	var label := RichTextLabel.new()
	label.text = product.text
	products.add_child(label)
	var title := product.title
	var max_width := 20
	if title.length() > max_width:
		title = title.left(max_width - 3).strip_edges() + "..."
	products.set_tab_title(products.get_child_count() - 1, title)

func _add_license(license: Nicense.License) -> void:
	var label := RichTextLabel.new()
	label.text = license.text
	licenses.add_child(label)
	licenses.set_tab_title(licenses.get_child_count() - 1, license.title)
