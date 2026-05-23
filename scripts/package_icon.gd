class_name PackageIcon
extends Control

@export var progress_bar: TextureProgressBar
@export var reward_label: RichTextLabel
@export var distance_pill: Panel
@export var distance_label: RichTextLabel

const FRAGILE_COLOR = "#21c0ce"
const HEAVY_COLOR = "#be2633"
const URGENT_COLOR = "#fab40b"
const NORMAL_COLOR = "#f9a31b"

var pill_color: Color

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
		distance_pill.self_modulate = pill_color
		distance_pill.show()
		distance_label.text = get_distance()
	else:
		progress_bar.texture_over = null
		distance_pill.hide()
	
	match package.property:
		Package.PackageProperty.URGENT:
			progress_bar.value = (package.urgent_time_left * 100) / RunData.stats.urgent_packages_time
			if package.urgent_time_left <= 0:
				reward_label.text = "$%s" % package.reward
		Package.PackageProperty.FRAGILE:
			progress_bar.value = ((RunData.stats.fragile_packages_health - package.fragile_health) * 100) / RunData.stats.fragile_packages_health

func setup(_package: Package):
	package = _package
	progress_bar.value = 0
	
	reward_label.text = "$%s" % package.reward
	
	match package.property:
		Package.PackageProperty.URGENT:
			pill_color = Color(URGENT_COLOR)
			reward_label.text = "[color=yellow]%s[/color]" % reward_label.text
			progress_bar.texture_under = urgent_icon
		Package.PackageProperty.FRAGILE:
			pill_color = Color(FRAGILE_COLOR)
			progress_bar.texture_under = fragile_icon
		Package.PackageProperty.HEAVY:
			pill_color = Color(HEAVY_COLOR)
			progress_bar.texture_under = heavy_icon
		Package.PackageProperty.NORMAL:
			pill_color = Color(NORMAL_COLOR)
			progress_bar.texture_under = normal_icon

func get_distance() -> String:
	var distance = GameManager.player.global_position.distance_to(package.goal.global_position)
	var meters: int = distance / TerrainManager.CHUNK_SIZE * 100.0
	
	return "%smt" % meters 
