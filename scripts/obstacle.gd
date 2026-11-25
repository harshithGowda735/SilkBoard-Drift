extends Area2D
class_name Obstacle

enum Kind { BUS, CAR, BARRICADE, COW }

var kind: Kind = Kind.CAR
var city: int = 0
var lane_u: float = 0.26
var speed: float = 55.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(func(b: Node2D) -> void:
		if b.name == "Player":
			get_tree().call_group("game_manager", "on_player_hit", self))
	var shape := RectangleShape2D.new()
	match kind:
		Kind.BUS:
			sprite.texture = PixelArt.bus(city)
			shape.size = Vector2(44, 20); speed = 42.0
		Kind.CAR:
			sprite.texture = PixelArt.car(city)
			shape.size = Vector2(28, 16); speed = 64.0
		Kind.BARRICADE:
			sprite.texture = PixelArt.barricade()
			shape.size = Vector2(36, 14); speed = 82.0
		Kind.COW:
			sprite.texture = PixelArt.cow()
			shape.size = Vector2(32, 14); speed = 78.0
	col.shape = shape
	col.disabled = true

func _physics_process(delta: float) -> void:
	var t: float = clampf((position.y - 96.0) / 174.0, 0.0, 1.2)
	position.y += speed * (0.25 + t * 1.65) * delta
	position.x = 240.0 + lane_u * lerpf(27.0, 222.0, t)
	var sc: float = lerpf(0.2, 1.15, clampf((position.y - 99.0) / 129.0, 0.0, 1.0))
	scale = Vector2(sc, sc)
	col.disabled = position.y < 213.0 or position.y > 243.0
	if position.y > 295.0:
		queue_free()
