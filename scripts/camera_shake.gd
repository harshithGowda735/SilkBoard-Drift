extends Camera2D

var _strength: float = 0.0

func shake(intensity: float) -> void:
	_strength = maxf(_strength, intensity)

func _process(delta: float) -> void:
	if _strength > 0.05:
		offset = Vector2(randf_range(-_strength, _strength), randf_range(-_strength, _strength))
		_strength = lerpf(_strength, 0.0, 12.0 * delta)
	else:
		_strength = 0.0
		offset = Vector2.ZERO
