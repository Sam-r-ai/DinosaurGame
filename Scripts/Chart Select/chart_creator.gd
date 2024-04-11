extends Node

const USER_SONGS_DIRECTORY = "user://Songs";

signal chart_initialized(path);

@export var song_field : OptionButton;
@export var bpm_field : SpinBox;
@export var name_field : LineEdit;

@onready var songs_directory = OS.get_user_data_dir() + "/Songs";

var song_option_dictionary = {};
var song_count : int = 0;

func _ready():
	check_songs_dir_exists();
	get_user_audio_streams_in_dir();

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

func get_user_audio_streams_in_dir():
	check_songs_dir_exists();
	
	song_field.clear();
	song_option_dictionary.clear();
	song_count = 0;
	
	
	var dir = DirAccess.open(USER_SONGS_DIRECTORY)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "mp3":
					add_song_option(USER_SONGS_DIRECTORY + "/" + file_name, file_name);
			file_name = dir.get_next()
		print("reached end of directory");
	else:
		print("error opening path");

func add_song_option(path, name):
	song_field.add_item(name, song_count);
	song_option_dictionary[song_count+1] = path;
	song_count += 1;

func initialize_chart():
	var name = name_field.text;
	var bpm = bpm_field.value;
	var song_path = song_option_dictionary[song_field.selected];
	
	var chart_path = OS.get_user_data_dir() + "/Charts/" + name + ".bin";
	print(chart_path);
	
	#"res://Charts/" + name + ".bin";
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

func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound

func check_songs_dir_exists():
	if DirAccess.dir_exists_absolute(songs_directory):
		print("directory exists");
	else:
		print("directory does not exist");
		DirAccess.make_dir_absolute(songs_directory);
