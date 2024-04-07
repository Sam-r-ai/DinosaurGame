extends Button

signal user_songs_added(path);

@export var directory_input : LineEdit;

const USER_SONGS_DIRECTORY = "user://User Songs";

func open_songs_dir():
	var given_directory = directory_input.text;
	
	if !given_directory:
		print("no directory given")
		return;
	
	print(given_directory);
	
	var dir = DirAccess.open(given_directory);
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				print("found directory");
			else:
				print("found file " + file_name);
				if (given_directory + file_name).get_extension() == "mp3":
					print("file is mp3")
					
					var test_output_path = "C:/Users/Admin/OneDrive/Desktop/test directory/test output directory";
					if dir.rename(given_directory + file_name, test_output_path):
						print("success");
				else:
					pass
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	print("user songs added emitted");
	user_songs_added.emit(USER_SONGS_DIRECTORY);

func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound
