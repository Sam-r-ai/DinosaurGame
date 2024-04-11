extends SceneRoot

const CHART_PATH = "res://Charts/";

@export var new_chart_button : Button;
@export var create_chart_window : Control;
@export var chart_button_scene : PackedScene;
@export var file_button_container : VBoxContainer;
@export var chart_button_container : VBoxContainer

@export var status_display : StatusDisplay;

var destination_scene : String = " ";
var buttons_created : int = 0;

var charts_directory : String;

func _ready():
	charts_directory = OS.get_user_data_dir() + "/Charts/";
	get_chart_files_in_dir(charts_directory);

func load_scene_parameters(new_scene_parameters):
	scene_parameters = new_scene_parameters;
	scene_parameters["chart path"] = null;
	destination_scene = scene_parameters["destination scene"];
	scene_parameters.erase("destination scene");
	
	if destination_scene == "chart editor":
		new_chart_button.visible = true;


func select_chart(path, button):
	print("chart select recieved");
	var save_dictionary : Dictionary = {};
	
	print("Chart Load Path: " + str(path));
	var chart_file = FileAccess.open(path, FileAccess.READ);
	if FileAccess.file_exists(path):
		if !chart_file.eof_reached():
			var data = JSON.parse_string(chart_file.get_line());
			if data:
				if typeof(data) == TYPE_DICTIONARY:
					save_dictionary = data;
				else:
					print("ERROR: chart load failed: invalid type");
					return;
			else:
				print("ERROR: chart load failed: data = null");
				return;
	else:
		status_display.display_message("Chart Path Invalid, bin file may be missing from Charts Folder", Color(1,0,0));
		return;
	
	if !FileAccess.file_exists(save_dictionary["song path"]):
		status_display.display_message("Song Path Invalid, mp3 file may be missing from Songs Folder", Color(1,0,0));
	else:
		scene_parameters["chart path"] = path;
		
		for child in file_button_container.get_children():
			if child is Button:
				child.disabled = true;
		
		for child in chart_button_container.get_children():
			if child is Button:
				child.disabled = true;
		
		change_scene.emit(scene_name, destination_scene);

func _on_new_chart_btn_pressed():
	create_chart_window.visible = true;
	
	for child in file_button_container.get_children():
		if child is Button:
			var button : Button = child;
			button.disabled = true;
	
	for child in chart_button_container.get_children():
		if child is Button:
			var button : Button = child;
			button.disabled = true;
	
	new_chart_button.release_focus();

func _on_cancel_btn_pressed():
	create_chart_window.visible = false;
	create_chart_window.release_focus();
	
	for child in file_button_container.get_children():
		if child is Button:
			var button : Button = child;
			button.disabled = false;
	
	for child in chart_button_container.get_children():
		if child is Button:
			var button : Button = child;
			button.disabled = false;

func get_chart_files_in_dir(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				pass;
			else:
				create_chart_access_button(file_name, charts_directory + file_name);
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func create_chart_access_button(chart_name : String, chart_path : String):
	var new_button = chart_button_scene.instantiate();
	new_button.assigned_chart = chart_name;
	new_button.chart_path = chart_path;
	new_button.text = new_button.assigned_chart;
	chart_button_container.add_child(new_button);
	
	buttons_created += 1;
	
	new_button.chart_selected.connect(select_chart);

func reload_charts():
	status_display.display_message("Charts Reloaded", Color(0,1,0));
	for child in chart_button_container.get_children():
		child.queue_free();
	
	get_chart_files_in_dir(charts_directory);

func _on_reload_songs_btn_pressed():
	status_display.display_message("Songs Reloaded", Color(0,1,0));
