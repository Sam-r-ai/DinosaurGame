extends Node2D;

class_name Chart;

@export var chart_editor : ChartEditor;
@export var note_parent : Node2D;
@export var trigger_parent: Node2D;
@export var song : AudioStream;

@onready var grid : Grid = chart_editor.grid;

var note_dictionary = {};

func save_chart():
	var note_count : int = 0;
	note_dictionary.clear();
	
	for note : ChartNote in note_parent.get_children():
		
		var index : int = note_dictionary.size();
		var note_data = []
		
		note_data = [Vector2(note.lane, note.timestamp)];
		note_dictionary[index] = note_data;

func load_chart():
	clear_chart();
	
	for note in note_dictionary:
		var note_data = note_dictionary[note];
		print(note_data[0]);
		
		var new_note = chart_editor.note_prefab.instantiate();
		new_note.global_position.x = note_data[0].x*grid.SPACE_SIZE.x;
		new_note.global_position.y = note_data[0].y * grid.SPACE_SIZE.y*chart_editor.beats_per_second*chart_editor.grid_spaces_per_beat *-1;
		note_parent.add_child(new_note);
		
		new_note.lane = note_data[0].x;
		new_note.timestamp = note_data[0].y;
	

func clear_chart():
	for note in note_parent.get_children():
		note.queue_free();
