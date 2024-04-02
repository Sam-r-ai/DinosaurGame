extends Node

const SONGS_DIRECTORY = "res://Sound Assets/Songs/";
const CHARTS_PATH = "res://Charts/";

@export var song_field : OptionButton;
@export var bpm_field : SpinBox;
@export var name_field : LineEdit;

var song_option_dictionary = {};

func _ready():
	get_audio_streams_in_dir(SONGS_DIRECTORY)

func get_audio_streams_in_dir(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if load(path + "/" + file_name) is AudioStream:
					add_song_option(path + "/" + file_name, file_name);
			file_name = dir.get_next()

func add_song_option(path, name):
	var song_count = song_option_dictionary.size();
	song_field.add_item(name, song_count);
	song_option_dictionary[song_count+1] = path;

func initialize_chart():
	print(song_option_dictionary);
	var name = name_field.text;
	var bpm = bpm_field.value;
	var song_path = song_option_dictionary[song_field.selected];
	
	var chart_path = "res://Charts/" + name + ".bin";
	var chart_file = FileAccess.open(chart_path, FileAccess.WRITE);
	
	var note_count : int = 0;
	print(song_option_dictionary);
	print(song_path);
	var save_dictionary = {
		"name" : name,
		"bpm" : bpm,
		"song path" : song_path,
		"notes" : {}
	}
	
	var jstr = JSON.stringify(save_dictionary);
	
	chart_file.store_line(jstr);
	ChartData.chart_path = chart_path;
	print("Chart: " + str(name) + " Created");
	
	get_tree().change_scene_to_file("res://Scenes/Screens/chart_editor.tscn");
