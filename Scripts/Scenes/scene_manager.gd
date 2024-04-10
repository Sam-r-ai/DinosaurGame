extends Node

class_name SceneManager;

@export var current_scene : Node;
@export var anim : AnimationPlayer;
@export var print_passed_parameters : bool = false;

var next_scene = null;

var scene_dictionary = {
	"main menu" : "main_menu",
	"chart select" : "chart_select",
	"chart editor" : "chart_editor",
	"play mode" : "play_mode",
	"credit scene" : "credit_scene",
}

func _ready():
	print("Initial Scene: " + current_scene.scene_name);
	current_scene.change_scene.connect(handle_scene_change);
	current_scene.on_loading_finished();

func handle_scene_change(current_scene_name, next_scene_name):
	if !scene_dictionary[next_scene_name]:
		print("next scene name invalid")
		return;
	
	next_scene = load("res://Scenes/Screens/" + scene_dictionary[next_scene_name] + ".tscn").instantiate();
	anim.play("fade_in");

func transfer_data_between_scenes(old_scene, new_scene):
	if print_passed_parameters:
		print("Printing passed scene parameters");
		print(old_scene.scene_parameters);
	new_scene.load_scene_parameters(old_scene.scene_parameters);

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			add_child(next_scene);
			transfer_data_between_scenes(current_scene, next_scene);
			current_scene.cleanup();
			next_scene.change_scene.connect(handle_scene_change);
			current_scene = next_scene;
			next_scene = null;
			anim.play("fade_out");
		"fade_out":
			current_scene.on_loading_finished();
