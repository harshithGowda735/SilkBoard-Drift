extends Node

var fare := 30.0
var multiplier := 1
var max_multiplier := 1
var time_left := 60.0
var health := 3
var started := false
var is_game_over := false
var invuln := false
@onready var player: CharacterBody2D = $"../Player"
@onready var near_miss: Area2D = $"../Player/NearMissZone"
@onready var hud: CanvasLayer = $"../HUD"
@onready var cam: Camera2D = $"../Camera2D"
@onready var fx: Node2D = $"../FX"

func _ready() -> void:
	add_to_group("game_manager")
	player.set_physics_process(false)
	near_miss.area_exited.connect(_on_near_miss_exited)

func _process(delta: float) -> void:
	if not started:
		if Input.is_action_just_pressed("squeeze"):
			started = true; player.set_physics_process(true); hud.hide_title(); hud.show_banner("METER DOWN! - BENGALURU")
		return
	if is_game_over:
		if Input.is_action_just_pressed("squeeze") or Input.is_key_pressed(KEY_R):
			get_tree().paused = false; get_tree().reload_current_scene()
		return
	time_left = maxf(0.0, time_left - delta)
	if time_left <= 0.0: _end_game(); return
	fx.set_heavy_rain(time_left <= 30.0)
	fx.set_sparks(Input.is_action_pressed("squeeze") and near_miss.has_overlapping_areas())
	fare += player.speed_mult * multiplier * 1.5 * delta
	hud.update_state(fare, multiplier, time_left, health)

func _on_near_miss_exited(area: Area2D) -> void:
	if not started or is_game_over or not (area is Obstacle) or area.has_meta("hit"): return
	multiplier = mini(8, multiplier + 1); max_multiplier = maxi(max_multiplier, multiplier)
	hud.pulse_meter(); cam.shake(1.5)
	var lbl := Label.new()
	lbl.text = "+%dx CLOSE CALL!" % multiplier
	lbl.position = player.global_position + Vector2(-28, -18)
	lbl.add_theme_font_size_override("font_size", 8)
	lbl.add_theme_color_override("font_color", Color("#ffbe0b"))
	get_parent().add_child(lbl)
	var tw := lbl.create_tween().set_parallel(true)
	tw.tween_property(lbl, "position:y", lbl.position.y - 16.0, 0.6)
	tw.tween_property(lbl, "modulate:a", 0.0, 0.6)
	tw.chain().tween_callback(lbl.queue_free)

func on_player_hit(obs: Area2D) -> void:
	if not started or is_game_over or invuln or obs.has_meta("hit"): return
	obs.set_meta("hit", true); multiplier = 1; health = maxi(0, health - 1); invuln = true
	cam.shake(5.0); Engine.time_scale = 0.05
	await get_tree().create_timer(0.06, true, false, true).timeout
	Engine.time_scale = 1.0
	if is_game_over: return
	var tw := create_tween()
	tw.tween_property(player, "modulate", Color(1, 0.3, 0.3, 0.4), 0.1)
	tw.tween_property(player, "modulate", Color.WHITE, 0.25)
	tw.tween_callback(func() -> void: invuln = false)
	if health <= 0: _end_game()

func _end_game() -> void:
	is_game_over = true; Engine.time_scale = 1.0; get_tree().paused = true
	hud.show_game_over(fare, max_multiplier)