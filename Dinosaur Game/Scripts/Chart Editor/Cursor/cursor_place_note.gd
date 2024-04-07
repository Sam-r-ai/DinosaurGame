extends State

@onready var cursor : Cursor = get_parent().parent;
@onready var chart_editor = cursor.chart_editor;
@onready var grid = chart_editor.grid;

var new_note : ChartNote = null;
var new_held_note : NoteHoldBar = null;
var click_position : Vector2;

func enter_state():
	cursor.can_scroll = true;
	cursor.can_zoom = true;
	
	click_position = cursor.global_position;
	
	new_note = chart_editor.note_prefab.instantiate();
	new_note.global_position.x = cursor.global_position.x;
	new_note.global_position.y = cursor.global_position.y;
	chart_editor.note_parent.add_child(new_note);
	
	new_note.lane = grid.get_grid_position(cursor.global_position).x;
	new_note.timestamp = new_note.global_position.y/(grid.SPACE_SIZE.y*chart_editor.beats_per_second*chart_editor.grid_spaces_per_beat)*-1;

func state_physics_process(delta):
	cursor.move();
	
	if cursor.global_position.y < click_position.y and new_held_note == null:
		new_held_note = chart_editor.note_hold_prefab.instantiate();
		new_held_note.global_position = cursor.global_position;
		chart_editor.note_parent.add_child(new_held_note);
	
	if new_held_note:
		new_held_note.global_position.y = cursor.global_position.y;
		new_held_note.update_length(click_position.y - new_held_note.global_position.y);
		new_note.hold_time = chart_editor.distance_to_seconds(new_note.global_position.y - new_held_note.global_position.y)
	
	if Input.is_action_just_released("Left Click"):
		change_state.emit(self, "Normal");

func exit_state():
	new_note = null;
	new_held_note = null;
