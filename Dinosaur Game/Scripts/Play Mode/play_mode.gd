extends SceneRoot

class_name PlayMode;

var bpm : float;
var song_path : String;
var note_dictionary = {};
var chart_path : String;

var save_dictionary : Dictionary = {};

var song_started : bool = false;

@export var pixels_per_second = 300;
@export var note_scene : PackedScene;
@export var held_note_scene : PackedScene;
@export var track : CharacterBody2D;
@export var song_player : AudioStreamPlayer;
@export var note_catcher : Area2D;

@export var start_label : Label;
@export var pause_menu : Control;

@export var score_display : Label;

var song_start_timer : SceneTreeTimer;

var score : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func load_scene_parameters(new_scene_parameters):
	scene_parameters = new_scene_parameters;
	chart_path = scene_parameters["chart path"];
	load_chart();
	
	song_player.stream = load(song_path);

func _physics_process(delta):
	if Input.is_action_just_pressed("Editor - Play or Pause") and !song_started:
		fall_down();
	
	if Input.is_action_just_pressed("Pause"):
		pause_menu.visible = true;
		get_tree().paused = true;

func update_score_display():
	score_display.text = "Score: " + str(score);

func load_chart():
	print("Chart Load Path: " + str(chart_path));
	var chart_file = FileAccess.open(chart_path, FileAccess.READ);
	if FileAccess.file_exists(chart_path):
		if !chart_file.eof_reached():
			var data = JSON.parse_string(chart_file.get_line());
			if data:
				if typeof(data) == TYPE_DICTIONARY:
					save_dictionary = data;
				else:
					print("chart load failed: invalid type");
			else:
				print("chart load failed: data = null");
	
	
	bpm = save_dictionary["bpm"];
	song_path = save_dictionary["song path"];
	note_dictionary = save_dictionary["notes"];
	
	load_notes();

func load_notes():
	for note in note_dictionary:
		var note_data = note_dictionary[note];
		var new_note = note_scene.instantiate();
		
		#Set Position
		new_note.lane = note_data[0].to_float();
		new_note.timestamp = note_data[1].to_float();
		new_note.hold_time = note_data[2].to_float();
		
		new_note.global_position.x = new_note.lane*160;
		new_note.global_position.y = new_note.timestamp*pixels_per_second*-1;
		
		#Set Hold Time
		if new_note.hold_time > 0:
			print("this note has a hold time greater than 0");
			var new_held_note : NoteHoldBar = held_note_scene.instantiate();
			new_held_note.update_length(new_note.hold_time*pixels_per_second)
			new_held_note.global_position = new_note.global_position;
			new_held_note.global_position.y -= new_held_note.length
			
			track.add_child(new_held_note);
		
		track.add_child(new_note);

func fall_down():
	if !song_started:
		song_started = true;
		start_label.visible = false;
		track.velocity.y = pixels_per_second;
		
		var offset = note_catcher.global_position.y - track.global_position.y;
		offset = offset/pixels_per_second;
		
		song_start_timer = get_tree().create_timer(offset);
		song_start_timer.timeout.connect(on_song_timer_timeout);

func on_song_timer_timeout():
	song_player.play();

func _on_pause_menu_quit_button_pressed():
	change_scene.emit(scene_name, "main menu");
	song_player.stream_paused = true;
	track.velocity.y = 0;

func _on_pause_menu_previous_scene_button_pressed():
	scene_parameters["destination scene"] = scene_name;
	change_scene.emit(scene_name, "chart select");
	song_player.stream_paused = true;
	track.velocity.y = 0;

func enter_edit_mode():
	scene_parameters["chart path"] = chart_path;
	change_scene.emit(scene_name, "chart editor");
	song_player.stream_paused = true;
	track.velocity.y = 0;

func restart_scene():
	scene_parameters["chart path"] = chart_path;
	change_scene.emit(scene_name, scene_name);
	song_player.stream_paused = true;
	track.velocity.y = 0;
