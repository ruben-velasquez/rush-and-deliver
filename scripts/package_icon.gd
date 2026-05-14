class_name PackageIcon
extends Control

@export var progress_bar: TextureProgressBar
@export var reward_label: RichTextLabel

@export var fragile_icon: Texture2D
@export var heavy_icon: Texture2D
@export var urgent_icon: Texture2D
@export var normal_icon: Texture2D
@export var seleted_outline: Texture2D

var package: Package

func _process(_delta: float) -> void:
	if !visible: return
	
	if GameManager.packages_manager.is_current_package(package):
		progress_bar.texture_over = seleted_outline
	else:
		progress_bar.texture_over = null
	
	match package.property:
		Package.PackageProperty.URGENT:
			progress_bar.value = (package.urgent_time_left * 100) / RunData.stats.urgent_packages_time
			reward_label.text = "$%s" % package.reward
		Package.PackageProperty.FRAGILE:
			progress_bar.value = ((RunData.stats.fragile_packages_health - package.fragile_health) * 100) / RunData.stats.fragile_packages_health

func setup(_package: Package):
	package = _package
	progress_bar.value = 0
	
	reward_label.text = "$%s" % package.reward
	
	match package.property:
		Package.PackageProperty.URGENT:
			progress_bar.texture_under = urgent_icon
		Package.PackageProperty.FRAGILE:
			progress_bar.texture_under = fragile_icon
		Package.PackageProperty.HEAVY:
			progress_bar.texture_under = heavy_icon
		Package.PackageProperty.NORMAL:
			progress_bar.texture_under = normal_icon
