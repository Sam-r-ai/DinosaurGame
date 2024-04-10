extends SceneRoot


func _on_texture_button_pressed():
	scene_parameters["destination scene"] = "main menu";
	change_scene.emit(scene_name, "main menu");
