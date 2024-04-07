extends State;

@onready var cursor : Cursor = get_parent().parent;
@onready var chart_editor = cursor.chart_editor;
@onready var grid = chart_editor.grid;

var pasted_notes : Dictionary = {};

func enter_state():
	cursor.can_scroll = true;
	cursor.can_zoom = false;
	
	load_clipboard();

func _on_ui_button_pressed(button):
	print(button.text);
	change_state.emit(self, button.text);

func state_physics_process(delta):
	cursor.move();
	cursor.can_set_song_progress();
	
	for entry in pasted_notes:
		var note = pasted_notes[entry];
		note.global_position.x = cursor.global_position.x + (note.lane)*grid.SPACE_SIZE.x;
		note.global_position.y = cursor.global_position.y + note.timestamp*chart_editor.pixels_per_second;
		
		note.global_position -= Vector2(2,1)*grid.SPACE_SIZE;
		
		if grid.get_grid_position(note.global_position).x > 5:
			var wrap_spaces = grid.get_grid_position(note.global_position).x - 5;
			note.global_position.x = (wrap_spaces) * grid.SPACE_SIZE.x
	
	if Input.is_action_just_pressed("Left Click") and cursor.is_mouse_in_range():
		place_notes();
		change_state.emit(self, "Paste");

func place_notes():
	for entry in pasted_notes:
		var obstructed = false;
		var note : ChartNote = pasted_notes[entry];
		
		note.lane = note.global_position.x/grid.SPACE_SIZE.x;
		note.timestamp = note.global_position.y/chart_editor.pixels_per_second;
		
		var overlapping_areas = note.get_overlapping_areas();
		for area in overlapping_areas:
			if area is ChartNote:
				if area.timestamp == note.timestamp and area.lane == note.lane:
					obstructed = true;
					print("note obstructed: not placed");
		
		if obstructed:
			note.queue_free();
	
	pasted_notes.clear();
	load_clipboard();

func load_clipboard():
	for entry in cursor.clipboard:
		var new_note : ChartNote = cursor.chart_editor.note_prefab.instantiate();
		var note_data = cursor.clipboard[entry];
		new_note.lane = note_data[0];
		new_note.timestamp = note_data[1];
		new_note.hold_time = note_data[2]
		
		new_note.global_position.x = note_data[0] * grid.SPACE_SIZE.x;
		new_note.global_position.y = cursor.global_position.y;
		new_note.global_position.y += note_data[1] * grid.SPACE_SIZE.y*chart_editor.beats_per_second*chart_editor.grid_spaces_per_beat *-1;
		
		chart_editor.note_parent.add_child(new_note);
		pasted_notes[pasted_notes.size()] = new_note;

func exit_state():
	clear_pasted_notes();

func clear_pasted_notes():
	for entry in pasted_notes:
		var note = pasted_notes[entry];
		note.queue_free();
	
	pasted_notes.clear();
