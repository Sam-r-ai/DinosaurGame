extends Button

@export var directory_input : LineEdit;

@export var open_directory = "user://Songs";

func open_songs_dir():
	release_focus();
	var user_songs_directory = ProjectSettings.globalize_path(open_directory);
	
	OS.shell_open(user_songs_directory);
	pass;
