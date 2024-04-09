extends Node2D;

class_name SaveManager;

var chart_name = "default"

@export var chart_editor : ChartEditor;
@export var note_parent : Node2D;
@export var trigger_parent: Node2D;
@export var song : AudioStream;
@export var chart_name_label : Label;

@export var paste_state : State;

@onready var grid : Grid = chart_editor.grid;


var chart_path : String;

var note_dictionary = {};
var trigger_dictionary = {};

@onready var save_dictionary = {
	"name" : " ",
	"bpm": chart_editor.bpm,
	"song path" : " ",
	"notes": note_dictionary
};

func update_chart_path(path : String):
	print("new chart path: " + path)
	chart_path = path;
	chart_name_label.text = chart_name;

func save_chart():
	paste_state.clear_pasted_notes();
	
	print(" ");
	print("Chart Save Path: " + str(chart_path));
	
	note_dictionary.clear();
	
	for note : ChartNote in note_parent.get_children():
		
		var index : int = note_dictionary.size();
		var note_data : Array = [str(note.lane), str(note.timestamp), str(note.hold_time)];
		
		note_dictionary[index] = note_data;
	
	save_dictionary["notes"] = note_dictionary;
	
	trigger_dictionary.clear();
	
	for trigger : Trigger in trigger_parent.get_children():
		
		var index : int = trigger_dictionary.size();
		var trigger_data : Array = [(trigger.function), str(trigger.timestamp)];
		
		trigger_dictionary[index] = trigger_data;
	
	save_dictionary["triggers"] = trigger_dictionary;
	
	var jstr = JSON.stringify(save_dictionary);
	
	var chart_file = FileAccess.open(chart_path, FileAccess.WRITE);
	
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
	
	var beats_per_second = chart_editor.bpm/60;
	var pixels_per_second = (grid.SPACE_SIZE.y*beats_per_second*chart_editor.grid_spaces_per_beat)*-1;
	
	for note in note_dictionary:
		if !typeof(note_dictionary[note]) == TYPE_ARRAY:
			print("chart load failed: not array");
		
		var note_data = note_dictionary[note];
		
		note_data[0] = note_data[0].to_float();
		note_data[1] = note_data[1].to_float();
		if note_data.size() >= 3:
			note_data[2] = note_data[2].to_float();
		
		var new_note : ChartNote = chart_editor.note_prefab.instantiate();
		
		new_note.lane = note_data[0];
		new_note.timestamp = note_data[1];
		
		new_note.global_position.x = new_note.lane * grid.SPACE_SIZE.x;
		new_note.global_position.y = new_note.timestamp * pixels_per_second;
		
		if note_data.size() >= 3:
			new_note.hold_time = note_data[2];
			
			if new_note.hold_time > 0:
				var new_held_note : NoteHoldBar = chart_editor.note_hold_prefab.instantiate();
				new_note.add_child(new_held_note);
				new_note.held_note = new_held_note;
				new_held_note.global_position.y += new_note.hold_time * pixels_per_second;
				new_held_note.end_point.global_position.y = new_note.global_position.y;
				new_held_note.stretch_to_end_point();
			
		note_parent.add_child(new_note);
		
		new_note.lane = note_data[0];
		new_note.timestamp = note_data[1];
	
	for entry in trigger_dictionary:
		var new_trigger : Trigger = chart_editor.trigger_prefab.instantiate();
		
		var trigger_data = trigger_dictionary[entry];
		new_trigger.function = trigger_data[0];
		new_trigger.timestamp = trigger_data[1];
		
		new_trigger.global_position.x = 0;
		new_trigger.global_position.y = new_trigger.timestamp * chart_editor.pixels_per_second;
		
		trigger_parent.add_child(new_trigger);
	
	chart_name_label.text = chart_name;
	print("Chart: " + str(chart_name) + " Loaded");

func clear_chart():
	for note in note_parent.get_children():
		note.queue_free();
	for trigger in trigger_parent.get_children():
		trigger.queue_free();

func on_name_text_submitted(new_text : String):
	pass;
