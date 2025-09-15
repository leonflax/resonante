extends Control

@export_file("*.tscn") var game_scene := "res://scenes/game.tscn"

@onready var jugar: RichTextLabel = %Jugar
@onready var salir: RichTextLabel = %Salir

const COLOR_BASE := Color.WHITE
var COLOR_HOVER := Color.html("#174f59")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false

	for l in [jugar, salir]:
		l.bbcode_enabled = false
		l.fit_content = true
		l.custom_minimum_size.y = 64
		l.mouse_filter = Control.MOUSE_FILTER_STOP
		l.add_theme_color_override("default_color", COLOR_BASE)
		l.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		# ¡Ojo al orden! Primero viene el event; el label va bindeado después
		l.gui_input.connect(_on_label_gui_input.bind(l))
		l.mouse_entered.connect(_on_label_mouse_enter.bind(l))
		l.mouse_exited.connect(_on_label_mouse_exit.bind(l))

func _on_label_gui_input(e: InputEvent, label: RichTextLabel) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		_act(label)
	elif e.is_action_pressed("ui_accept"):
		_act(label)

func _act(label: RichTextLabel) -> void:
	if label == jugar:
		if !ResourceLoader.exists(game_scene):
			push_error("[MainMenu] La ruta de game_scene no existe: %s" % game_scene)
			return
		get_tree().change_scene_to_file(game_scene)
	elif label == salir:
		get_tree().quit()

func _on_label_mouse_enter(label: RichTextLabel) -> void:
	label.add_theme_color_override("default_color", COLOR_HOVER)

func _on_label_mouse_exit(label: RichTextLabel) -> void:
	label.add_theme_color_override("default_color", COLOR_BASE)
