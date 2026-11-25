extends Node2D

const HORIZON_Y := 96.0
const BOT_Y := 270.0

var scroll: float = 0.0
var city_idx: int = 0
var sky_top := Color("#24113d")
var sky_bot := Color("#e05a47")
var ground_col := Color("#1e2920")
var tree_tex: Texture2D
var target_sky := sky_top
var target_sky2 := sky_bot
var target_ground := ground_col

func _ready() -> void:
	tree_tex = PixelArt.tree(false)

func set_city(idx: int, cfg: Dictionary) -> void:
	city_idx = idx
	target_sky = cfg["sky"]
	target_sky2 = cfg["sky2"]
	target_ground = cfg["ground"]
	tree_tex = PixelArt.tree(idx == 1)

func step(speed: float, delta: float) -> void:
	scroll = fmod(scroll + speed * delta * 0.014, 1.0)
	sky_top = sky_top.lerp(target_sky, 2.0 * delta)
	sky_bot = sky_bot.lerp(target_sky2, 2.0 * delta)
	ground_col = ground_col.lerp(target_ground, 2.0 * delta)
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0, 0, 480, 24), sky_top)
	draw_rect(Rect2(0, 24, 480, 24), sky_top.lerp(Color("#7b2cbf"), 0.6))
	draw_rect(Rect2(0, 48, 480, 24), sky_bot)
	draw_rect(Rect2(0, 72, 480, 24), Color("#f4a261"))
	draw_circle(Vector2(240, 82), 22.0, Color("#fde047"))
	_draw_skyline()
	draw_rect(Rect2(0, HORIZON_Y, 480, BOT_Y - HORIZON_Y), ground_col)
	var road_pts := PackedVector2Array([Vector2(213, HORIZON_Y), Vector2(267, HORIZON_Y), Vector2(462, BOT_Y), Vector2(18, BOT_Y)])
	draw_colored_polygon(road_pts, Color("#262b44"))
	for i: int in 12:
		var t0: float = fmod((float(i) / 12.0) + scroll, 1.0)
		var t1: float = fmod((float(i + 1) / 12.0) + scroll, 1.0)
		var y0: float = HORIZON_Y + t0 * t0 * (BOT_Y - HORIZON_Y)
		var y1: float = HORIZON_Y + t1 * t1 * (BOT_Y - HORIZON_Y) if t1 > t0 else BOT_Y
		var hw0: float = lerpf(27.0, 222.0, (y0 - HORIZON_Y) / (BOT_Y - HORIZON_Y))
		var hw1: float = lerpf(27.0, 222.0, (y1 - HORIZON_Y) / (BOT_Y - HORIZON_Y))
		var sc: float = lerpf(0.15, 1.2, (y0 - HORIZON_Y) / (BOT_Y - HORIZON_Y))
		var kcol := Color("#f5c400") if i % 2 == 0 else Color("#18181b")
		draw_colored_polygon(PackedVector2Array([Vector2(240 - hw0 - 5 * sc, y0), Vector2(240 - hw0, y0), Vector2(240 - hw1, y1), Vector2(240 - hw1 - 5 * sc, y1)]), kcol)
		draw_colored_polygon(PackedVector2Array([Vector2(240 + hw0, y0), Vector2(240 + hw0 + 5 * sc, y0), Vector2(240 + hw1 + 5 * sc, y1), Vector2(240 + hw1, y1)]), kcol)
		if city_idx == 0:
			draw_rect(Rect2(240 - hw0 - 16 * sc, y0 - 8 * sc, 10 * sc, 8 * sc), Color("#1d4ed8"))
		if i % 2 == 0:
			draw_rect(Rect2(240 - hw0 * 0.5, y0, 3 * sc, 10 * sc), Color.WHITE)
			draw_rect(Rect2(240 + hw0 * 0.5, y0, 3 * sc, 10 * sc), Color.WHITE)
		draw_rect(Rect2(240 - 3 * sc, y0, 6 * sc, 8 * sc), Color("#475569"))
		if city_idx != 2:
			draw_texture_rect(tree_tex, Rect2(240 - hw0 - 54 * sc, y0 - 50 * sc, 56 * sc, 64 * sc), false)
			draw_texture_rect(tree_tex, Rect2(240 + hw0 + 4 * sc, y0 - 50 * sc, 56 * sc, 64 * sc), false)

func _draw_skyline() -> void:
	for x: int in range(0, 480, 24):
		var h: int = 16 + ((x * 7) % 24)
		draw_rect(Rect2(x, HORIZON_Y - h, 22, h), Color(0.08, 0.06, 0.14, 0.9))
		draw_rect(Rect2(x + 4, HORIZON_Y - h + 4, 3, 3), Color("#fde047"))
		draw_rect(Rect2(x + 12, HORIZON_Y - h + 9, 3, 3), Color("#fde047"))
	if city_idx == 0:
		draw_rect(Rect2(60, 74, 360, 4), Color("#475569"))
		for px: int in [100, 190, 290, 380]: draw_rect(Rect2(px, 78, 7, 18), Color("#64748b"))
	elif city_idx == 1:
		draw_rect(Rect2(0, 88, 480, 8), Color("#64748b"))
	elif city_idx == 2:
		for px: int in range(90, 400, 36): draw_rect(Rect2(px, 70, 7, 26), Color("#d6d3d1"))
	else:
		for px: int in [80, 240, 400]:
			draw_line(Vector2(px, 96), Vector2(px + 28, 52), Color("#94a3b8"), 2.0)
			draw_line(Vector2(px + 28, 52), Vector2(px + 56, 96), Color("#94a3b8"), 2.0)
