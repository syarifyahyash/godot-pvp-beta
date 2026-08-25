extends Node2D

@export var grid_size: Vector2i = Vector2i(4, 4)
@export var cell_size: Vector2 = Vector2(100, 100)
@export var unit_scene: PackedScene = preload("res://scenes/unit.tscn")

var grid_data: Dictionary = {}
var original_cell: Vector2i = Vector2i(-1, -1)


func _ready() -> void:
	initialize_grid()
	queue_redraw()
	
	# Spawn 2 unit untuk tes merge (di sel 0,0 dan 1,0)
	spawn_unit(Vector2i(0, 0))
	spawn_unit(Vector2i(1, 0))


func initialize_grid() -> void:
	grid_data.clear()
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var cell := Vector2i(x, y)
			grid_data[cell] = null


func _draw() -> void:
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var rect = Rect2(Vector2(x * cell_size.x, y * cell_size.y), cell_size)
			draw_rect(rect, Color.WHITE, false, 2.0)


func get_cell_center(cell: Vector2i) -> Vector2:
	return Vector2(
		cell.x * cell_size.x + cell_size.x / 2.0,
		cell.y * cell_size.y + cell_size.y / 2.0
	)


func get_cell_from_position(pos: Vector2) -> Vector2i:
	var local_pos = to_local(pos)
	var cell_x = int(floor(local_pos.x / cell_size.x))
	var cell_y = int(floor(local_pos.y / cell_size.y))
	return Vector2i(cell_x, cell_y)


func is_valid_cell(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < grid_size.x and cell.y >= 0 and cell.y < grid_size.y


func spawn_unit(cell: Vector2i) -> Unit:
	if not is_valid_cell(cell) or grid_data[cell] != null:
		return null

	if unit_scene == null:
		return null

	var new_unit = unit_scene.instantiate() as Unit
	add_child(new_unit)
	new_unit.position = get_cell_center(cell)
	grid_data[cell] = new_unit
	
	# Sambungkan signal drag dari unit
	new_unit.drag_started.connect(_on_unit_drag_started)
	new_unit.drag_ended.connect(_on_unit_drag_ended)
	
	return new_unit


func _on_unit_drag_started(unit: Unit) -> void:
	original_cell = get_cell_from_position(unit.global_position)


func _on_unit_drag_ended(unit: Unit) -> void:
	var target_cell = get_cell_from_position(unit.global_position)
	
	# Cek apakah dropped di luar grid
	if not is_valid_cell(target_cell):
		unit.position = get_cell_center(original_cell)
		return

	# Kasus 1: Pindah ke sel kosong
	if grid_data[target_cell] == null:
		grid_data[original_cell] = null
		grid_data[target_cell] = unit
		unit.position = get_cell_center(target_cell)
		
	# Kasus 2: Ditaruh di sel asal sendiri
	elif target_cell == original_cell:
		unit.position = get_cell_center(original_cell)
		
	# Kasus 3: Merge jika unit tipe & level-nya sama
	else:
		var target_unit: Unit = grid_data[target_cell]
		if target_unit.unit_type == unit.unit_type and target_unit.level == unit.level:
			grid_data[original_cell] = null
			target_unit.upgrade()
			unit.queue_free()
		else:
			# Jika beda tipe/level, kembalikan ke posisi asal
			unit.position = get_cell_center(original_cell)
