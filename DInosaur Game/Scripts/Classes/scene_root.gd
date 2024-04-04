extends Node

class_name SceneRoot;

@export var scene_name = "no scene name";

signal change_scene(scene_name);

var scene_parameters : Dictionary;

func on_loading_finished():
	pass;

func load_scene_parameters(new_scene_parameters):
	scene_parameters = new_scene_parameters;
	#Any Extra Loading Steps

func cleanup():
	queue_free();
