extends Control

const LINES := [
	"SILK BOARD IS DEADLOCKED. MY DEMO STARTS IN 60S... AND BATTERY IS AT 2%!",
	"HOP IN BOSS! WHEN TRAFFIC STOPS, WE SHIFT INTO 8-BIT OVERDRIVE!",
	"HOLD [SHIFT] TO COMPRESS PIXELS & SQUEEZE THROUGH TRAFFIC!",
	"METER DOWN! HANG ON TIGHT, BOSS!",
]

var panel: int = -1
var typing: float = 0.0
@onready var portrait: TextureRect = $Panel/Portrait
@onready var mini_demo: Node2D = $Panel/MiniDemo
@onready var meter_box: ColorRect = $Panel/MeterBox
@onready var dialog: Label = $DialogBox/DialogText
@onready var flash: ColorRect = $Flash
@onready var wipe: ColorRect = $Wipe
@onready var sfx: AudioStreamPlayer = $Sfx

func _ready() -> void:
	$Panel/MiniDemo/BusL.texture = PixelArt.bus(0)
	$Panel/MiniDemo/BusR.texture = PixelArt.bus(0)
	$Panel/MiniDemo/Auto.texture = PixelArt.auto_rickshaw(true)
	_next_panel()

func _process(delta: float) -> void:
	if dialog.visible_characters < dialog.text.length():
		typing += delta * 42.0
		dialog.visible_characters = int(typing)
	if panel == 2:
		var s := 0.72 + 0.15 * sin(Time.get_ticks_msec() * 0.01)
		$Panel/MiniDemo/Auto.scale = Vector2(s, 1.0)
	if Input.is_action_just_pressed("ui_cancel"):
		_go_main()
	elif Input.is_action_just_pressed("squeeze"):
		if dialog.visible_characters < dialog.text.length():
			dialog.visible_characters = dialog.text.length()
		else:
			_next_panel()

func _next_panel() -> void:
	panel += 1
	if panel >= 4:
		_go_main()
		return
	typing = 0.0
	dialog.visible_characters = 0
	dialog.text = LINES[panel]
	portrait.visible = panel < 2
	mini_demo.visible = panel == 2
	meter_box.visible = panel == 3
	if panel == 0:
		portrait.texture = PixelArt.portrait_founder()
	elif panel == 1:
		flash.color = Color("#f5c400"); flash.modulate.a = 0.85
		create_tween().tween_property(flash, "modulate:a", 0.0, 0.3)
		portrait.texture = PixelArt.portrait_driver()
		portrait.position.x = 180.0
		create_tween().tween_property(portrait, "position:x", 24.0, 0.25)
	elif panel == 3:
		meter_box.scale.y = 0.0
		create_tween().tween_property(meter_box, "scale:y", 1.0, 0.22)
		_play_rev()

func _play_rev() -> void:
	sfx.play()
	var pb := sfx.get_stream_playback() as AudioStreamGeneratorPlayback
	if pb == null: return
	for i: int in mini(int(22050.0 * 0.35), pb.get_frames_available()):
		var t: float = float(i) / 22050.0
		var s: float = sin(TAU * (110.0 + t * 420.0) * t) * 0.22
		pb.push_frame(Vector2(s, s))

func _go_main() -> void:
	set_process(false)
	var mat := wipe.material as ShaderMaterial
	var tw := create_tween()
	tw.tween_method(func(v: float) -> void: mat.set_shader_parameter("wipe_progress", v), 0.0, 1.0, 0.35)
	tw.tween_callback(func() -> void: get_tree().change_scene_to_file("res://scenes/main.tscn"))
