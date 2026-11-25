extends CharacterBody2D

const MOVE_SPEED := 185.0

var speed_mult: float = 1.0
var tex_normal: Texture2D
var tex_tilt: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var col: CollisionShape2D = $CollisionShape2D
@onready var horn_player: AudioStreamPlayer = $HornPlayer

func _ready() -> void:
	tex_normal = PixelArt.auto_rickshaw(false)
	tex_tilt = PixelArt.auto_rickshaw(true)
	sprite.texture = tex_normal

func _physics_process(delta: float) -> void:
	var steer: float = Input.get_axis("left", "right")
	var throttle: float = Input.get_axis("down", "up")
	var squeezing: bool = Input.is_action_pressed("squeeze")

	sprite.texture = tex_tilt if squeezing else tex_normal
	sprite.scale.x = 0.8 if squeezing else 1.0
	(col.shape as RectangleShape2D).size.x = 12.0 if squeezing else 24.0
	speed_mult = clampf(1.0 + throttle * 0.45, 0.6, 1.45) * (1.25 if squeezing else 1.0)

	velocity.x = lerpf(velocity.x, steer * MOVE_SPEED * (1.2 if squeezing else 1.0), 10.0 * delta)
	velocity.y = 0.0
	move_and_slide()
	position.x = clampf(position.x, 54.0, 426.0)
	position.y = 228.0

	if Input.is_action_just_pressed("horn"):
		_play_horn()

func _play_horn() -> void:
	if not horn_player.playing:
		horn_player.play()
	var pb := horn_player.get_stream_playback() as AudioStreamGeneratorPlayback
	if pb == null:
		return
	for i: int in mini(int(22050.0 * 0.12), pb.get_frames_available()):
		var t: float = float(i) / 22050.0
		var s: float = (sin(TAU * 440.0 * t) + sin(TAU * 554.0 * t)) * 0.2
		pb.push_frame(Vector2(s, s))
