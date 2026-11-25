extends Node

const CITIES := [
	{ "name": "STOP 1: BENGALURU - SILK BOARD", "sky": Color("#3b1d4a"), "sky2": Color("#e06c43"), "ground": Color("#263028") },
	{ "name": "STOP 2: MUMBAI - MARINE DRIVE", "sky": Color("#1d2b53"), "sky2": Color("#ff8c42"), "ground": Color("#1e3a5f") },
	{ "name": "STOP 3: DELHI - CONNAUGHT PLACE", "sky": Color("#4a3b2c"), "sky2": Color("#f4a261"), "ground": Color("#3d352e") },
	{ "name": "STOP 4: KOLKATA - HOWRAH BRIDGE", "sky": Color("#2b193d"), "sky2": Color("#d65a31"), "ground": Color("#263028") },
]

var city_idx: int = 0
var city_timer: float = 0.0
var next_fare_stop: float = 330.0
@onready var road: Node2D = $"../Road25D"
@onready var hud: CanvasLayer = $"../HUD"
@onready var gm: Node = $"../GameManager"

func _process(delta: float) -> void:
	if not gm.started or gm.is_game_over:
		return
	city_timer += delta
	if city_timer >= 15.0 or gm.fare >= next_fare_stop:
		city_timer = 0.0
		next_fare_stop = gm.fare + 300.0
		city_idx = (city_idx + 1) % CITIES.size()
		gm.time_left += 10.0
		road.set_city(city_idx, CITIES[city_idx])
		hud.city_wipe()
		hud.show_banner(CITIES[city_idx]["name"])
