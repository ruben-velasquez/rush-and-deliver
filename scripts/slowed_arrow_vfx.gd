extends Sprite2D

var animate: bool = false

const ANIMATION_VELOCITY = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var packageManager = GameManager.packages_manager
	
	packageManager.on_swap_package.connect(func():
		var _animate = PackagesManager.is_heavy(packageManager.get_current_package())
		
		if animate == _animate: return
		animate = _animate
		
		if animate and RunData.stats.heavy_packages_speed_mult < 1:
			var tween = create_tween()
			tween.tween_property(self, "self_modulate", Color.WHITE, 0.5).set_trans(Tween.TRANS_BOUNCE)
			tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 0.5).set_trans(Tween.TRANS_BOUNCE)
		else:
			self_modulate.a = 0
	)

func _process(_delta: float) -> void:
	if animate:
		show()
		offset.y = sin(Time.get_ticks_msec() / 1000.0 * ANIMATION_VELOCITY)
	else:
		hide()
