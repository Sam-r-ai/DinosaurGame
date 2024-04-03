extends SceneRoot

const CHART_PATH = "res://Charts/";

@export var new_chart_button : Button;
@export var create_chart_window : Control;
@export var chart_button_scene : PackedScene;
@export var button_parent : Control;

var destination_scene : String = " ";
var buttons_created : int = 0;


func _ready():
	get_chart_files_in_dir(CHART_PATH);
	new_chart_button.global_position = Vector2(0,buttons_created*new_chart_button.size.y);

func load_scene_parameters(new_scene_parameters):
	scene_parameters = new_scene_parameters;
	scene_parameters["chart path"] = null;
	destination_scene = scene_parameters["destination scene"];
	scene_parameters.erase("destination scene");

func select_chart(path):
	scene_parameters["chart path"] = path;
	change_scene.emit(scene_name, destination_scene);

func _on_new_chart_btn_pressed():
	create_chart_window.visible = true;
	button_parent.visible = false;
	new_chart_button.release_focus();

func _on_cancel_btn_pressed():
	button_parent.visible = true;
	create_chart_window.visible = false;
	create_chart_window.release_focus();

func get_chart_files_in_dir(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				pass;
			else:
				create_chart_access_button(file_name, CHART_PATH + file_name);
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func create_chart_access_button(chart_name : String, chart_path : String):
	var new_button = chart_button_scene.instantiate();
	new_button.assigned_chart = chart_name;
	new_button.chart_path = chart_path;
	new_button.text = new_button.assigned_chart;
	add_child(new_button);
	new_button.global_position = Vector2(0,buttons_created*new_button.size.y);
	new_button.chart_selected.connect(select_chart);
	
	buttons_created += 1;
