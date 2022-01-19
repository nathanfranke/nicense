extends Node

func _ready():
	Nicense.add_product(Nicense.Product.new("My Project", [
		Nicense.Copyright.new(
			["2021, Nathan Franke"],
			"My License"
		)
	]))
	Nicense.add_license(Nicense.License.new("My License", "This software shall be used for good, not evil."))
