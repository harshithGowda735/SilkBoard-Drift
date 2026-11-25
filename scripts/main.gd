extends Node2D

var score: float = 0.0
@onready var player: CharacterBody2D = $Player
@onready var cam: Camera2D = $Camera2D
@onready var road: Node2D = $Road25D
@onready var spawner: Node = $TrafficSpawner

func _physics_process(delta: float) -> void:
	cam.position.x = lerpf(cam.position.x, 240.0 + (player.position.x - 240.0) * 0.1, 8.0 * delta)
	var spd: float = 90.0 * player.speed_mult
	road.step(spd, delta)
	score += spd * delta * 0.1
	spawner.score = score
