extends Node2D;

class_name SaveManager;

var chart_name = "default"

@export var chart_editor : ChartEditor;
@export var note_parent : Node2D;
@export var trigger_parent: Node2D;
@export var song : AudioStream;
@export var chart_name_label : Label;

@onready var grid : Grid = chart_editor.grid;


var chart_path : String;
var note_dictionary = {};

@onready var save_dictionary = {
	"name" : " ",
	"bpm": chart_editor.bpm,
	"song path" : " ",
	"notes": note_dictionary
};

func update_chart_path(path : String):
	chart_path = path;
	chart_name_label.text = chart_name;

func save_chart():
	print(" ");
	print("Chart Save Path: " + str(chart_path));
	var chart_file = FileAccess.open(chart_path, FileAccess.WRITE);
	
	var note_count : int = 0;
	note_dictionary.clear();
	
	for note : ChartNote in note_parent.get_children():
		
		var index : int = note_dictionary.size();
		var note_data : Array = [str(note.lane), str(note.timestamp)]
		
		note_dictionary[index] = note_data;
	
	save_dictionary["notes"] = note_dictionary;
	var jstr = JSON.stringify(save_dictionary);
	
	chart_file.store_line(jstr);
	print("Chart: " + str(chart_name) + " Saved");

func load_chart():
	print(" ");
	print("Chart Load Path: " + str(chart_path));
	var chart_file = FileAccess.open(chart_path, FileAccess.READ);
	if FileAccess.file_exists(chart_path):
		if !chart_file.eof_reached():
			var data = JSON.parse_string(chart_file.get_line());
			if data:
				if typeof(data) == TYPE_DICTIONARY:
					save_dictionary = data;
				else:
					print("chart load failed: invalid type");
			else:
				print("chart load failed: data = null");
	
	
	clear_chart();
	
	chart_name = save_dictionary["name"];
	chart_editor.bpm = save_dictionary["bpm"];
	chart_editor.song = load(save_dictionary["song path"]);
	note_dictionary = save_dictionary["notes"];
	
	for note in note_dictionary:
		if !typeof(note_dictionary[note]) == TYPE_ARRAY:
			print("chart load failed: not array");
		
		var note_data = note_dictionary[note];
		
		note_data[0] = note_data[0].to_float();
		note_data[1] = note_data[1].to_float();
		
		var new_note = chart_editor.note_prefab.instantiate();
		new_note.global_position.x = note_data[0] * grid.SPACE_SIZE.x;
		new_note.global_position.y = note_data[1] * grid.SPACE_SIZE.y*chart_editor.beats_per_second*chart_editor.grid_spaces_per_beat *-1;
		note_parent.add_child(new_note);
		
		new_note.lane = note_data[0];
		new_note.timestamp = note_data[1];
	
	chart_name_label.text = chart_name;
	print("Chart: " + str(chart_name) + " Loaded");

func clear_chart():
	for note in note_parent.get_children():
		note.queue_free();

func on_name_text_submitted(new_text : String):
	pass;
