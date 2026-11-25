class_name PixelArt

static func _load_or(file: String, w: int, h: int, fn: Callable, sh_rx: int = 14, sh_ry: int = 4) -> Texture2D:
	var path := "res://assets/sprites/" + file
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	fn.call(img)
	_outline(img, Color("#12101c"))
	_oval_shadow(img, w / 2, h - sh_ry - 1, sh_rx, sh_ry)
	return ImageTexture.create_from_image(img)

static func _r(img: Image, list: Array) -> void:
	for a: Array in list:
		img.fill_rect(Rect2i(a[0], a[1], a[2], a[3]), a[4])

static func _blob(img: Image, cx: int, cy: int, rx: int, ry: int, col: Color) -> void:
	for y: int in range(maxi(1, cy - ry), mini(img.get_height() - 1, cy + ry + 1)):
		for x: int in range(maxi(1, cx - rx), mini(img.get_width() - 1, cx + rx + 1)):
			var dx := float(x - cx) / maxf(1.0, float(rx))
			var dy := float(y - cy) / maxf(1.0, float(ry))
			if dx * dx + dy * dy <= 1.0:
				img.set_pixel(x, y, col)

static func _outline(img: Image, col: Color) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var pts: Array[Vector2i] = []
	for y: int in range(1, h - 1):
		for x: int in range(1, w - 1):
			if img.get_pixel(x, y).a == 0.0:
				if img.get_pixel(x - 1, y).a > 0.5 or img.get_pixel(x + 1, y).a > 0.5 or img.get_pixel(x, y - 1).a > 0.5 or img.get_pixel(x, y + 1).a > 0.5:
					pts.append(Vector2i(x, y))
	for p: Vector2i in pts:
		img.set_pixel(p.x, p.y, col)

static func _oval_shadow(img: Image, cx: int, cy: int, rx: int, ry: int) -> void:
	for y: int in range(maxi(0, cy - ry), mini(img.get_height(), cy + ry + 1)):
		for x: int in range(maxi(0, cx - rx), mini(img.get_width(), cx + rx + 1)):
			if img.get_pixel(x, y).a == 0.0:
				var dx := float(x - cx) / maxf(1.0, float(rx))
				var dy := float(y - cy) / maxf(1.0, float(ry))
				if dx * dx + dy * dy <= 1.0:
					img.set_pixel(x, y, Color(0, 0, 0, 0.38))

static func auto_rickshaw(tilted: bool = false) -> Texture2D:
	return _load_or("auto_tilt.png" if tilted else "auto.png", 48, 48, func(img: Image) -> void:
		var base := Image.create(48, 48, false, Image.FORMAT_RGBA8)
		_r(base, [
			[10, 21, 28, 17, Color("#15803d")], [11, 22, 26, 4, Color("#22c55e")], [10, 34, 28, 4, Color("#14532d")],
			[12, 7, 24, 15, Color("#f5c400")], [14, 7, 20, 4, Color("#fde047")], [12, 19, 24, 3, Color("#ca8a04")],
			[14, 14, 20, 9, Color("#1e293b")], [20, 14, 8, 5, Color("#92400e")], [18, 19, 12, 4, Color("#38bdf8")],
			[20, 26, 8, 9, Color("#18181b")], [22, 28, 4, 5, Color("#64748b")],
			[8, 33, 6, 9, Color("#18181b")], [34, 33, 6, 9, Color("#18181b")],
			[11, 30, 4, 3, Color("#ff2e4c")], [33, 30, 4, 3, Color("#ff2e4c")], [12, 31, 2, 1, Color("#fda4af")], [34, 31, 2, 1, Color("#fda4af")],
		])
		if not tilted:
			img.blit_rect(base, Rect2i(0, 0, 48, 48), Vector2i.ZERO)
		else:
			var ang := deg_to_rad(-25.0)
			var cs := cos(ang); var sn := sin(ang)
			for y: int in 48:
				for x: int in 48:
					var sx := int(roundf((x - 24) * cs - (y - 26) * sn + 24))
					var sy := int(roundf((x - 24) * sn + (y - 26) * cs + 26))
					if sx >= 0 and sx < 48 and sy >= 0 and sy < 48:
						var c := base.get_pixel(sx, sy)
						if c.a > 0.0: img.set_pixel(x, y, c)
	, 16, 4)

static func bus(city: int = 0) -> Texture2D:
	return _load_or("bus.png", 64, 96, func(img: Image) -> void:
		var c1 := Color("#dc2626") if city == 1 else (Color("#d97706") if city == 3 else Color("#1d4ed8"))
		var ch := Color("#ef4444") if city == 1 else (Color("#fbbf24") if city == 3 else Color("#3b82f6"))
		var cd := Color("#991b1b") if city == 1 else (Color("#92400e") if city == 3 else Color("#1e3a8a"))
		_r(img, [
			[10, 10, 44, 76, c1], [10, 10, 44, 14, Color("#f8fafc")], [12, 12, 40, 4, Color("#cbd5e1")],
			[16, 4, 14, 6, Color("#e2e8f0")], [34, 4, 14, 6, Color("#e2e8f0")],
			[13, 20, 38, 22, Color("#0f172a")], [15, 22, 14, 6, Color("#38bdf8")],
			[15, 38, 16, 2, Color("#94a3b8")], [33, 38, 16, 2, Color("#94a3b8")],
			[18, 14, 28, 4, Color("#fbbf24")], [10, 46, 44, 34, ch], [10, 74, 44, 12, cd],
			[6, 24, 4, 8, Color("#475569")], [54, 24, 4, 8, Color("#475569")],
			[13, 66, 8, 4, Color("#fef08a")], [43, 66, 8, 4, Color("#fef08a")],
			[12, 82, 8, 8, Color("#18181b")], [44, 82, 8, 8, Color("#18181b")],
		]), 24, 5)

static func car(city: int = 0) -> Texture2D:
	if randi() % 2 == 1 and city in [0, 2]:
		return _load_or("scooter.png", 32, 40, func(img: Image) -> void:
			var col := Color("#dc2626") if city == 0 else Color("#0284c7")
			_r(img, [
				[11, 16, 10, 18, col], [12, 18, 8, 6, Color("#ef4444")],
				[11, 6, 10, 9, Color("#f8fafc")], [10, 12, 12, 6, Color("#1e293b")],
				[8, 15, 16, 2, Color("#94a3b8")], [13, 21, 6, 3, Color("#fef08a")],
				[13, 29, 6, 7, Color("#18181b")],
			]), 9, 3)
	return _load_or("car.png", 48, 48, func(img: Image) -> void:
		var body := Color("#18181b") if city == 1 else (Color("#facc15") if city == 3 else (Color("#f8fafc") if city == 2 else Color("#94a3b8")))
		var roof := Color("#facc15") if city == 1 else body.lightened(0.2)
		var sh := body.darkened(0.25)
		_r(img, [
			[8, 22, 32, 18, body], [8, 35, 32, 5, sh], [11, 10, 26, 13, roof],
			[13, 13, 22, 9, Color("#0f172a")], [15, 14, 8, 3, Color("#38bdf8")],
			[9, 38, 6, 6, Color("#18181b")], [33, 38, 6, 6, Color("#18181b")],
			[10, 29, 6, 3, Color("#fef08a")], [32, 29, 6, 3, Color("#fef08a")],
		]), 17, 4)

static func barricade() -> Texture2D:
	return _load_or("barricade.png", 48, 24, func(img: Image) -> void:
		_r(img, [
			[7, 14, 4, 7, Color("#94a3b8")], [37, 14, 4, 7, Color("#94a3b8")],
			[4, 5, 40, 12, Color("#1d4ed8")], [4, 5, 40, 3, Color("#3b82f6")],
			[7, 8, 34, 7, Color("#f8fafc")], [10, 10, 28, 2, Color("#1e293b")],
			[21, 2, 6, 3, Color("#ff2e4c")], [23, 2, 2, 2, Color("#fecdd3")],
		]), 18, 3)

static func cow() -> Texture2D:
	return _load_or("cow.png", 44, 32, func(img: Image) -> void:
		_r(img, [
			[9, 11, 24, 13, Color("#f8fafc")], [14, 12, 10, 8, Color("#92400e")],
			[29, 8, 9, 9, Color("#78350f")], [28, 6, 3, 2, Color("#cbd5e1")], [36, 6, 3, 2, Color("#cbd5e1")],
			[10, 22, 4, 6, Color("#cbd5e1")], [27, 22, 4, 6, Color("#78350f")],
		]), 15, 3)

static func tree(palm: bool = false) -> Texture2D:
	return _load_or("tree.png", 56, 64, func(img: Image) -> void:
		if palm:
			_r(img, [[25, 20, 6, 36, Color("#78350f")], [26, 20, 2, 36, Color("#451a03")]])
			_blob(img, 28, 16, 18, 6, Color("#15803d"))
			_blob(img, 28, 12, 14, 5, Color("#22c55e"))
		else:
			_r(img, [[25, 32, 6, 24, Color("#78350f")], [26, 32, 2, 24, Color("#451a03")]])
			_blob(img, 28, 24, 18, 14, Color("#b83b5e"))
			_blob(img, 22, 20, 13, 10, Color("#f6757a"))
			_blob(img, 34, 21, 12, 10, Color("#f6757a"))
			_blob(img, 28, 15, 11, 8, Color("#ff9ebb"))
	, 14, 4)

static func portrait_founder() -> Texture2D:
	return _load_or("founder.png", 64, 64, func(img: Image) -> void:
		_r(img, [
			[14, 40, 36, 20, Color("#2563eb")], [16, 42, 32, 18, Color("#1d4ed8")],
			[20, 14, 24, 26, Color("#e0a97d")], [20, 34, 24, 6, Color("#c68652")],
			[18, 8, 28, 10, Color("#1e293b")], [18, 14, 4, 8, Color("#1e293b")], [42, 14, 4, 8, Color("#1e293b")],
			[21, 21, 9, 7, Color("#0f172a")], [34, 21, 9, 7, Color("#0f172a")], [30, 23, 4, 2, Color("#0f172a")],
			[23, 23, 5, 3, Color("#bae6fd")], [36, 23, 5, 3, Color("#bae6fd")],
			[28, 32, 8, 3, Color("#7f1d1d")],
			[36, 44, 22, 16, Color("#475569")], [38, 46, 18, 11, Color("#0f172a")], [42, 49, 10, 5, Color("#ff2e4c")], [44, 50, 2, 3, Color("#fecdd3")],
		]), 0, 0)

static func portrait_driver() -> Texture2D:
	return _load_or("driver.png", 64, 64, func(img: Image) -> void:
		_r(img, [
			[12, 40, 40, 20, Color("#eab308")], [16, 42, 32, 18, Color("#ca8a04")],
			[22, 40, 6, 14, Color("#18181b")], [36, 40, 6, 14, Color("#18181b")],
			[20, 14, 24, 26, Color("#a1623b")], [20, 34, 24, 6, Color("#7c4728")],
			[18, 8, 28, 9, Color("#18181b")],
			[20, 21, 10, 6, Color("#0f172a")], [34, 21, 10, 6, Color("#0f172a")], [30, 22, 4, 2, Color("#0f172a")],
			[22, 22, 4, 2, Color("#38bdf8")], [36, 22, 4, 2, Color("#38bdf8")],
			[26, 30, 12, 3, Color("#18181b")], [28, 34, 8, 2, Color("#f8fafc")],
		]), 0, 0)
