class_name Unit
extends Area2D

signal drag_started(unit: Unit)
signal drag_ended(unit: Unit)

@export var unit_type: String = "Corn"
@export var level: int = 1
@export var base_damage: float = 10.0

@onready var level_label: Label = $LevelLabel

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	update_visuals()
	input_event.connect(_on_input_event)


func _unhandled_input(event: InputEvent) -> void:
	# Deteksi mouse release di manapun di layar agar dragging selalu berhenti pas dilepas
	if is_dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		stop_drag()
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_dragging:
			start_drag()
			get_viewport().set_input_as_handled() # Hentikan klik agar tidak tembus ke unit lain


func start_drag() -> void:
	is_dragging = true
	drag_offset = get_global_mouse_position() - global_position
	z_index = 10 # Tampil paling depan saat ditarik
	drag_started.emit(self)


func stop_drag() -> void:
	is_dragging = false
	z_index = 0
	drag_ended.emit(self)


func update_visuals() -> void:
	if level_label:
		level_label.text = "%s\nLv.%d" % [unit_type, level]


func set_level(new_level: int) -> void:
	level = new_level
	update_visuals()


func upgrade() -> void:
	level += 1
	update_visuals()


func get_attack_power() -> float:
	return base_damage * level
