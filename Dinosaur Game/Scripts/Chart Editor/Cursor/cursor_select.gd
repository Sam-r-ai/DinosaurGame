extends State

@onready var cursor : Cursor = get_parent().parent;
@onready var chart_editor : ChartEditor = cursor.chart_editor;;
@onready var grid = chart_editor.grid;

var selection_origin_position : Vector2;
var selection_box_size : Vector2;

var selection_box : Area2D;

func enter_state():
	cursor.can_scroll = true;
	cursor.can_zoom = true;

func state_physics_process(delta):
	cursor.move();
	cursor.can_set_song_progress();
	
	if Input.is_action_just_pressed("Left Click"):
		if selection_box:
			selection_box.queue_free();
		
		selection_origin_position = cursor.global_position;
		selection_origin_position.y -= 40;
		selection_box = cursor.selection_box_scene.instantiate();
		selection_box.global_position = selection_origin_position;
		add_sibling(selection_box);
	
	if Input.is_action_pressed("Left Click"):
		selection_box_size = cursor.global_position - selection_origin_position;
		selection_box.scale = grid.get_grid_position(cursor.global_position - selection_origin_position) + Vector2(1,0);
	
	if selection_box:
		if Input.is_action_just_pressed("Editor - Copy"):
			
			
			cursor.clipboard.clear();
			
			for area in selection_box.get_overlapping_areas():
				if area is ChartNote:
					add_note_to_clipboard(area);
			
			print(cursor.clipboard);
			
		elif Input.is_action_just_pressed("Editor - Cut"):
			cursor.clipboard.clear();
			
			for area in selection_box.get_overlapping_areas():
				if area is ChartNote:
					add_note_to_clipboard(area);
					area.queue_free();
			
			print(cursor.clipboard);

func exit_state():
	if selection_box:
		selection_box.queue_free();
		selection_box = null;

func add_note_to_clipboard(note : ChartNote):
	var pixels_per_second = (grid.SPACE_SIZE.y*chart_editor.beats_per_second*chart_editor.grid_spaces_per_beat)*-1;
	
	var index = cursor.clipboard.size();
	var relative_timestamp = (note.global_position.y - selection_origin_position.y)/pixels_per_second;
	print(relative_timestamp);
	var note_data = [note.lane, relative_timestamp, note.hold_time];
	cursor.clipboard[index] = note_data

func _on_normal_button_ui_button_pressed(button):
	if get_parent().current_state == self:
		change_state.emit(self, button.text);
