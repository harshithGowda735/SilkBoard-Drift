class_name PixelArt

static func _tex(file: String, w: int, h: int, fn: Callable) -> Texture2D:
	var path := "res://assets/sprites/" + file
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	fn.call(img)
	return ImageTexture.create_from_image(img)

static func auto_rickshaw(tilted: bool = false) -> Texture2D:
	return _tex("auto_tilt.png" if tilted else "auto.png", 48, 48, func(img: Image) -> void:
		img.fill_rect(Rect2i(10, 10, 28, 28), Color("#f5c400")))

static func bus(_city: int = 0) -> Texture2D:
	return _tex("bus.png", 64, 96, func(img: Image) -> void:
		img.fill_rect(Rect2i(10, 10, 44, 76), Color("#1d4ed8")))

static func car(_city: int = 0) -> Texture2D:
	return _tex("car.png", 48, 48, func(img: Image) -> void:
		img.fill_rect(Rect2i(8, 12, 32, 28), Color("#facc15")))

static func barricade() -> Texture2D:
	return _tex("barricade.png", 44, 24, func(img: Image) -> void:
		img.fill_rect(Rect2i(4, 14, 4, 8), Color("#64748b"))
		img.fill_rect(Rect2i(36, 14, 4, 8), Color("#64748b"))
		img.fill_rect(Rect2i(2, 4, 40, 12), Color("#1d4ed8"))
		img.fill_rect(Rect2i(5, 7, 34, 6), Color("#f8fafc"))
		img.fill_rect(Rect2i(19, 1, 6, 3), Color("#ff2e4c")))

static func cow() -> Texture2D:
	return _tex("cow.png", 40, 28, func(img: Image) -> void:
		img.fill_rect(Rect2i(6, 10, 24, 12), Color("#f8fafc"))
		img.fill_rect(Rect2i(12, 11, 9, 7), Color("#78350f"))
		img.fill_rect(Rect2i(27, 7, 8, 8), Color("#78350f"))
		img.fill_rect(Rect2i(8, 21, 3, 6), Color("#cbd5e1"))
		img.fill_rect(Rect2i(24, 21, 3, 6), Color("#78350f")))

static func tree(palm: bool = false) -> Texture2D:
	return _tex("tree.png", 48, 56, func(img: Image) -> void:
		img.fill_rect(Rect2i(21, 24, 6, 28), Color("#5a3e28"))
		var col := Color("#16a34a") if palm else Color("#f6757a")
		img.fill_rect(Rect2i(8, 8, 32, 18), col)
		img.fill_rect(Rect2i(14, 4, 20, 12), Color("#22c55e") if palm else Color("#ff9ebb")))
