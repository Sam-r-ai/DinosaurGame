extends Area2D

class_name Cursor;

signal song_progress_moved;

@export var chart_editor : ChartEditor;
@export var left_bound : float;
@export var right_bound : float;
@export var selection_box_scene : PackedScene;


@onready var grid = chart_editor.grid;
@onready var scroll_speed = grid.SPACE_SIZE.y;
@onready var song_progress_line = chart_editor.song_progress_line;

var selected_note : ChartNote;
var new_note : ChartNote;
var new_note_hold_bar : NoteHoldBar;

var click_position : Vector2;
var holding_click : bool = false;
var placing_note : bool = false;

var can_scroll : bool = false;
var can_zoom : bool = false;

var clipboard : Dictionary = {};

func _physics_process(delta):
	if holding_click and new_note_hold_bar and (global_position.y < click_position.y):
		new_note_hold_bar.global_position.y = global_position.y;
		new_note_hold_bar.update_length(click_position.y - global_position.y);

func _input(event):
	if event is InputEventMouseButton and event.pressed and is_mouse_in_range():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			on_mouse_scroll(-1);
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			on_mouse_scroll(1);

func move():
	var mouse_position = get_viewport().get_mouse_position();
	if is_mouse_in_range():
		global_position = mouse_position;
		global_position.y += chart_editor.camera.global_position.y-648/2;
		
		global_position = grid.get_position_aligned_to_grid(global_position);
		
		global_position.x = clamp(global_position.x, grid.SPACE_SIZE.x, (grid.size.x-1)*grid.SPACE_SIZE.x);

func on_left_click_release():
	holding_click = false;
	if placing_note:
		placing_note = false;
		if (global_position.y < click_position.y):
			new_note_hold_bar.update_length(click_position.y - global_position.y);
			new_note.hold_time = chart_editor.distance_to_seconds(new_note_hold_bar.length);
			print(new_note.hold_time);
			new_note_hold_bar = null;
		else:
			if new_note_hold_bar:
				new_note_hold_bar.queue_free();
	
	click_position = Vector2(0,0);

func is_mouse_in_range():
	var mouse_position = get_viewport().get_mouse_position();
	if (left_bound < mouse_position.x) and (mouse_position.x < right_bound):
		return true;
	else:
		return false;

func place_note():
	holding_click = true;
	click_position = global_position;
	
	new_note = chart_editor.note_prefab.instantiate();
	new_note.global_position.x = global_position.x;
	new_note.global_position.y = global_position.y;
	chart_editor.note_parent.add_child(new_note);
	
	new_note.lane = grid.get_grid_position(global_position).x;
	new_note.timestamp = new_note.global_position.y/(grid.SPACE_SIZE.y*chart_editor.beats_per_second*chart_editor.grid_spaces_per_beat)*-1;
	
	
	
	new_note_hold_bar = chart_editor.note_hold_prefab.instantiate();
	new_note.add_child(new_note_hold_bar);
	placing_note = true;

func on_middle_click():
	pass;

func can_set_song_progress():
	if Input.is_action_just_pressed("Middle Click"):
		song_progress_line.global_position.y = global_position.y;
		if (song_progress_line.global_position.y > 0):
			song_progress_line.global_position.y = 0;
		song_progress_moved.emit();

func on_mouse_scroll(scroll_direction : float):
	if can_zoom and Input.is_action_pressed("Shift"):
		chart_editor.change_spaces_per_beat(2.0**-scroll_direction);
	elif can_scroll:
		chart_editor.camera.global_position.y += scroll_direction*scroll_speed;

func get_overlapping_note():
	var overlapping_areas = get_overlapping_areas();
	for area in overlapping_areas:
		if area is ChartNote:
			return area;
	return false;

func get_overlapping_held_note():
	var overlapping_areas = get_overlapping_areas();
	for area in overlapping_areas:
		if area is NoteHoldBar:
			return area;
	return false;
