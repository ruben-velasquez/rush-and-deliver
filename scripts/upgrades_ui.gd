extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for upgrade in UpgradesManager.current_upgrades:
		var img = TextureRect.new()
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		img.custom_minimum_size = Vector2(32., 32.)
		img.texture = UpgradesManager.get_icon(upgrade.id)
		img.tooltip_text = upgrade.get_description()
		add_child(img)
