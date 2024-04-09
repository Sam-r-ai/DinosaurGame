extends SceneRoot

func _ready():
	scene_parameters = {
		"destination scene" : null
	}

func _on_quit_button_pressed():
	get_tree().quit()

func _on_play_button_pressed():
	scene_parameters["destination scene"] = "chart editor";
	change_scene.emit(scene_name, "chart select");

func _on_play_mode_btn_pressed():
	scene_parameters["destination scene"] = "play mode";
	
	change_scene.emit(scene_name, "chart select");
