# <img src="https://raw.githubusercontent.com/nathanfranke/nicense/main/static/nicense.svg" width=24> Nicense - Godot Licensing Made Easy

Licensing is complicated and tedious. This addon adds a preset window dialog and button that can show an interactive list of all engine licenses. Custom licenses can be added through the Nicense singleton.

```py
func _ready():
	Nicense.add_product(Nicense.Product.new("My Project", [
		Nicense.Copyright.new(
			["2021, Nathan Franke"],
			"My License"
		)
	]))
	Nicense.add_license(Nicense.License.new("My License", "This software shall be used for good, not evil."))
```

![example of Nicense in use](https://raw.githubusercontent.com/nathanfranke/nicense/main/static/example.png)
