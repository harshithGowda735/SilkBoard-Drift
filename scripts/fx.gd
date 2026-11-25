extends Node2D

var rain: GPUParticles2D
var sparks: GPUParticles2D

func _ready() -> void:
	rain = _spawn_fx(Vector2(240, -6), 1, 5, Color("#8ce0ff"), 140, 1.3, Vector3(260, 4, 0), Vector3(-0.25, 1, 0), 240.0)
	rain.amount_ratio = 0.35
	_spawn_fx(Vector2(240, -6), 2, 2, Color("#f6757a"), 36, 4.8, Vector3(250, 4, 0), Vector3(-0.35, 1, 0), 50.0)
	sparks = _spawn_fx(Vector2.ZERO, 2, 2, Color("#ffbe0b"), 18, 0.25, Vector3(6, 8, 0), Vector3(0, 1, 0), 55.0)
	sparks.emitting = false
	sparks.reparent($"../Player", false)

func set_heavy_rain(heavy: bool) -> void:
	rain.amount_ratio = 1.0 if heavy else 0.35

func set_sparks(active: bool) -> void:
	sparks.emitting = active

func _spawn_fx(pos: Vector2, w: int, h: int, col: Color, amt: int, life: float, box: Vector3, dir: Vector3, spd: float) -> GPUParticles2D:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(col)
	var mat := ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	mat.emission_box_extents = box
	mat.direction = dir
	mat.spread = 12.0
	mat.initial_velocity_min = spd * 0.8
	mat.initial_velocity_max = spd * 1.15
	mat.gravity = Vector3.ZERO
	var p := GPUParticles2D.new()
	p.position = pos
	p.z_index = 5
	p.amount = amt
	p.lifetime = life
	p.texture = ImageTexture.create_from_image(img)
	p.process_material = mat
	add_child(p)
	return p
