extends Area2D

class_name Cursor;

signal song_progress_moved;

@export var chart_editor : ChartEditor;
@export var left_bound : float;
@export var right_bound : float;


@onready var grid = chart_editor.grid;
@onready var scroll_speed = grid.SPACE_SIZE.y;
@onready var song_progress_line = chart_editor.song_progress_line;

var selected_note : ChartNote;

func _physics_process(delta):
	var mouse_position = get_viewport().get_mouse_position();
	if is_mouse_in_range():
		global_position = mouse_position;
		global_position.y += chart_editor.camera.global_position.y-648/2;
		
		global_position = grid.get_position_aligned_to_grid(global_position);
		
		global_position.x = clamp(global_position.x, grid.SPACE_SIZE.x, (grid.size.x-1)*grid.SPACE_SIZE.x);

func _input(event):
	
	if event is InputEventMouseButton and event.pressed and is_mouse_in_range():
		if event.button_index == MOUSE_BUTTON_LEFT:
			on_left_click();
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			on_right_click();
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			on_mouse_scroll(-1);
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			on_mouse_scroll(1);
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			on_middle_click();

func is_mouse_in_range():
	var mouse_position = get_viewport().get_mouse_position();
	if (left_bound < mouse_position.x) and (mouse_position.x < right_bound):
		return true;
	else:
		return false;

func place_note():
	var new_note = chart_editor.note_prefab.instantiate();
	new_note.global_position.x = global_position.x;
	new_note.global_position.y = global_position.y;
	chart_editor.note_parent.add_child(new_note);
	
	new_note.lane = grid.get_grid_position(global_position).x;
	new_note.timestamp = new_note.global_position.y/(grid.SPACE_SIZE.y*chart_editor.beats_per_second*chart_editor.grid_spaces_per_beat)*-1;
	

func on_middle_click():
	song_progress_line.global_position.y = global_position.y;
	if (song_progress_line.global_position.y > 0):
		song_progress_line.global_position.y = 0;
	song_progress_moved.emit();

func on_mouse_scroll(scroll_direction : float):
	if Input.is_action_pressed("Shift"):
		chart_editor.change_spaces_per_beat(2.0**-scroll_direction);
	else:
		chart_editor.camera.global_position.y += scroll_direction*scroll_speed;

func on_left_click():
	var note_clicked = get_overlapping_note();
	if !note_clicked:
		place_note();
	else:
		selected_note = note_clicked;
		print("Lane: " + str(selected_note.lane));
		print("Timestamp: " + str(selected_note.timestamp));

func on_right_click():
	var note = get_overlapping_note();
	if note:
		note.queue_free();
	else:
		print("no note here");

func get_overlapping_note():
	var overlapping_areas = get_overlapping_areas();
	for area in overlapping_areas:
		if area is ChartNote:
			return area;
	return false;
