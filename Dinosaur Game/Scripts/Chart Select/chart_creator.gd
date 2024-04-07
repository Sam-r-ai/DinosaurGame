extends Node

const SONGS_DIRECTORY = "res://Sound Assets/Songs/";
const USER_SONGS_DIRECTORY = "user://User Songs";
const CHARTS_PATH = "res://Charts/";

signal chart_initialized(path);

@export var song_field : OptionButton;
@export var bpm_field : SpinBox;
@export var name_field : LineEdit;

var song_option_dictionary = {};

var user_song_dictionary = {};

var song_count : int = 0;

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

func get_user_audio_streams_in_dir(path):
	print("get user audio streams called");
	
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if load(path + "/" + file_name) is AudioStream:
					print(file_name + " IS AudioStream");
					#add_user_song_option(path + "/" + file_name, file_name);
				else:
					print(file_name + "file is NOT AudioStream");
			file_name = dir.get_next()
		print("reached end of directory");
	else:
		print("error opening path");

func add_song_option(path, name):
	song_field.add_item(name, song_count);
	song_option_dictionary[song_count+1] = path;
	song_count += 1;

func add_user_song_option(path, name):
	if !user_song_dictionary.values().has(path):
		return
	song_field.add_item(name, song_count);
	user_song_dictionary[user_song_dictionary.size()] = path;

func initialize_chart():
	var name = name_field.text;
	var bpm = bpm_field.value;
	var song_path = song_option_dictionary[song_field.selected];
	
	var chart_path = "res://Charts/" + name + ".bin";
	var chart_file = FileAccess.open(chart_path, FileAccess.WRITE);
	
	var note_count : int = 0;
	var save_dictionary = {
		"name" : name,
		"bpm" : bpm,
		"song path" : song_path,
		"notes" : {}
	}
	print(save_dictionary);
	
	var jstr = JSON.stringify(save_dictionary);
	
	chart_file.store_line(jstr);
	print("Chart: " + str(name) + " Created");
	
	chart_initialized.emit(chart_path);
	#get_tree().change_scene_to_file("res://Scenes/Screens/chart_editor.tscn");
