extends HBoxContainer

const ICONS: AtlasDB = preload("res://objects/upgrade_icons.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for upgrade in UpgradesManager.current_upgrades:
		var img = TextureRect.new()
		img.texture = ICONS.sprites.get(upgrade.id)
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		add_child(img)
