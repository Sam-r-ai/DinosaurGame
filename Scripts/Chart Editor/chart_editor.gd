extends SceneRoot;

class_name ChartEditor;

@export_category("Parameters")

var song : AudioStream;
var bpm : float;
@export var grid_spaces_per_beat = 4;
@export var camera_follow_song_bar : bool = false;

@export_category("Node References")

@export var cursor : Cursor;
@export var note_prefab : PackedScene;
@export var note_hold_prefab : PackedScene;
@export var trigger_prefab : PackedScene;
@export var note_parent : Node2D;
@export var trigger_parent : Node2D;
@export var camera : Camera2D;
@export var song_player : AudioStreamPlayer;
@export var song_progress_line : CharacterBody2D;
@export var grid : Grid;
@export var save_manager : SaveManager; 
@export var spaces_per_beat_display : SpinBox;

@export var status_display : StatusDisplay;

var seconds_per_beat : float;
var beats_per_second : float;
var song_progress_line_speed : float;
var pixels_per_second : float;

var changing_scene : bool = false;

@onready var grid_camera_offset = grid.global_position - camera.global_position;

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("Editor - Play or Pause"):
		on_play_or_pause();
	
	if song_player.playing and camera_follow_song_bar:
		camera.global_position.y -= song_progress_line_speed*delta;

func load_scene_parameters(new_scene_parameters):
	scene_parameters = new_scene_parameters;
	print("scene parameters loading");
	
	save_manager.update_chart_path(scene_parameters["chart path"]);
	save_manager.load_chart();
	print(bpm);
	seconds_per_beat = 60/bpm;
	beats_per_second = bpm/60;
	song_progress_line_speed = grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat;
	pixels_per_second = (grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat)*-1;
	print(song_progress_line_speed);
	
	spaces_per_beat_display.value = grid_spaces_per_beat
	
	song_player.stream = song;
	song_player.play();
	song_player.set_stream_paused(true);
	print("scene parameters loaded")

func set_song_line_speed():
	song_progress_line_speed = grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat*song_player.pitch_scale;

func enter_play_mode():
	save_manager.save_chart();
	scene_parameters["chart path"] = save_manager.chart_path;
	change_scene.emit(scene_name, "play mode");

func change_spaces_per_beat(change_multiplier : float):
	if (grid_spaces_per_beat*change_multiplier >= 1):
		print("new spaces per beat: " + str(grid_spaces_per_beat*change_multiplier));
		
		song_player.set_stream_paused(true);
		song_progress_line.velocity.y = 0;
		
		grid_spaces_per_beat *= change_multiplier;
		spaces_per_beat_display.value = grid_spaces_per_beat;
		
		pixels_per_second = (grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat)*-1
		
		for note in note_parent.get_children():
			var current_grid_position = grid.get_grid_position(note.global_position);
			var new_position = (((current_grid_position.y)*change_multiplier)*grid.SPACE_SIZE.y);
			note.global_position.y = (new_position);
			
			if note.hold_time > 0:
				var held_note = note.held_note;
				held_note.global_position = note.global_position
				held_note.global_position.y += note.hold_time * pixels_per_second;
				held_note.end_point.global_position.y = note.global_position.y;
				held_note.stretch_to_end_point();
		
		for trigger in trigger_parent.get_children():
			var current_grid_position = grid.get_grid_position(trigger.global_position);
			var new_position = (((current_grid_position.y)*change_multiplier)*grid.SPACE_SIZE.y);
			trigger.global_position.y = (new_position);
		
		song_progress_line_speed = grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat
		song_progress_line.global_position.y *= change_multiplier;
		
		var cursor_grid_position = grid.get_grid_position(cursor.global_position);
		var new_cursor_grid_position = cursor_grid_position;
		
		new_cursor_grid_position.y *= change_multiplier;
		
		var camera_offset_y = (new_cursor_grid_position.y - cursor_grid_position.y)*grid.SPACE_SIZE.y;
		
		camera.global_position.y += camera_offset_y;
		
		pixels_per_second = (grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat)*-1;
		
	else:
		print("spaces per beat cannot be less than 1");

func set_song_progress():
	var time = abs(song_progress_line.global_position.y / song_progress_line_speed);
	print("set song progress: " + str(time) + " seconds");	
	song_player.set_stream_paused(false);
	song_player.seek(time);
	pause_song();
	song_progress_line.velocity.y = 0;

func on_play_or_pause():
	if !song_player.playing:
		play_song();
	else:
		pause_song();

func play_song():
	song_player.set_stream_paused(false);
	song_progress_line.velocity.y = -song_progress_line_speed;
	song_progress_line.area2d.process_mode = PROCESS_MODE_INHERIT;
	if camera_follow_song_bar:
		camera.global_position.y = song_progress_line.global_position.y + grid_camera_offset.y + grid.SPACE_SIZE.y;

func pause_song():
	song_player.set_stream_paused(true);
	song_progress_line.velocity.y = 0;
	song_progress_line.area2d.process_mode = PROCESS_MODE_DISABLED;
	for note in note_parent.get_children():
		note.reset();

func distance_to_seconds(distance):
	return abs(distance/(grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat));

func seconds_to_distance(seconds):
	return abs(seconds*(grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat));

func _on_time_sig_input_value_changed(new_spaces_per_beat):
	var change_multiplier = new_spaces_per_beat/grid_spaces_per_beat;
	change_spaces_per_beat(change_multiplier);

func _on_song_select_btn_pressed():
	if !changing_scene:
		changing_scene = true;
		save_manager.save_chart();
		scene_parameters["destination scene"] = scene_name;
		change_scene.emit(scene_name, "chart select");

func _on_menu_btn_pressed():
	if !changing_scene:
		changing_scene = true;
		save_manager.save_chart();
		change_scene.emit(scene_name, "main menu");
