extends CanvasLayer

@onready var fare_lbl: Label = $TopBar/FareLabel
@onready var hp_bar: ProgressBar = $TopBar/HealthBar
@onready var time_lbl: Label = $TopBar/TimeLabel
@onready var meter_lbl: Label = $TopBar/MeterLabel
@onready var banner_lbl: Label = $BannerLabel
@onready var title_panel: Control = $TitlePanel
@onready var game_over_panel: Control = $GameOverPanel
@onready var final_fare_lbl: Label = $GameOverPanel/VBox/FinalFare
@onready var final_mult_lbl: Label = $GameOverPanel/VBox/FinalMult
@onready var crt: ColorRect = $CRT

var crt_on: bool = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_C:
		crt_on = not crt_on
		(crt.material as ShaderMaterial).set_shader_parameter("scan_alpha", 0.14 if crt_on else 0.0)

func city_wipe() -> void:
	var mat := crt.material as ShaderMaterial
	var tw := create_tween()
	tw.tween_method(func(v: float) -> void: mat.set_shader_parameter("wipe_progress", v), 0.0, 1.0, 0.22)
	tw.tween_method(func(v: float) -> void: mat.set_shader_parameter("wipe_progress", v), 1.0, 0.0, 0.25)

func _ready() -> void:
	game_over_panel.visible = false
	banner_lbl.modulate.a = 0.0
	meter_lbl.pivot_offset = Vector2(34, 6)

func update_state(fare: float, mult: int, time_left: float, health: int) -> void:
	fare_lbl.text = "♥ FARE: ₹%03d" % int(fare)
	hp_bar.value = health
	time_lbl.text = "TIME: %02d" % ceili(time_left)
	meter_lbl.text = "MULTIPLIER: x%d" % mult

func pulse_meter() -> void:
	var tw := create_tween()
	tw.tween_property(meter_lbl, "scale", Vector2(1.3, 1.3), 0.08)
	tw.tween_property(meter_lbl, "scale", Vector2.ONE, 0.14)

func show_banner(text: String) -> void:
	banner_lbl.text = text
	var tw := create_tween()
	tw.tween_property(banner_lbl, "modulate:a", 1.0, 0.25)
	tw.tween_interval(1.6)
	tw.tween_property(banner_lbl, "modulate:a", 0.0, 0.4)

func show_game_over(fare: float, max_mult: int) -> void:
	final_fare_lbl.text = "FARE EARNED: ₹%d" % int(fare)
	final_mult_lbl.text = "MAX MULTIPLIER: x%d" % max_mult
	game_over_panel.visible = true

func hide_title() -> void:
	title_panel.visible = false
