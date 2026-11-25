extends Node

const OBSTACLE_SCENE := preload("res://scenes/obstacle.tscn")
const LANES_U: Array[float] = [-0.72, -0.26, 0.26, 0.72]

var score: float = 0.0
@onready var timer: Timer = $Timer
@onready var city_mgr: Node = $"../CityManager"

func _ready() -> void:
	timer.wait_time = 1.2
	timer.timeout.connect(_on_spawn)
	timer.start()

func _on_spawn() -> void:
	var lanes: Array[float] = LANES_U.duplicate()
	lanes.shuffle()
	var count: int = 2 if randf() < 0.35 else 1
	for i: int in count:
		var obs: Obstacle = OBSTACLE_SCENE.instantiate()
		obs.city = city_mgr.city_idx
		obs.kind = (randi() % 4) as Obstacle.Kind
		obs.lane_u = lanes[i]
		obs.position = Vector2(240.0 + lanes[i] * 27.0, 99.0)
		obs.z_index = 2
		get_parent().add_child(obs)
	timer.wait_time = maxf(0.45, 1.2 - score * 0.0007)
