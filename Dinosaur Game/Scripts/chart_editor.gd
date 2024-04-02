extends Node2D

class_name ChartEditor;

@export_category("Parameters")

var song : AudioStream;
@export var bpm : float = 0;
@export var grid_spaces_per_beat = 4;
@export var camera_follow_song_bar : bool = false;

@export_category("Node References")

@export var cursor : Cursor;
@export var note_prefab : PackedScene;
@export var note_parent : Node2D;
@export var trigger_parent : Node2D;
@export var camera : Camera2D;
@export var song_player : AudioStreamPlayer;
@export var song_progress_line : CharacterBody2D;
@export var grid : Grid;
@export var save_manager : SaveManager; 


@onready var seconds_per_beat = 60/bpm;
@onready var beats_per_second = bpm/60;

@onready var song_progress_line_speed = grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat;

@onready var grid_camera_offset = grid.global_position - camera.global_position;

func _ready():
	save_manager.load_chart();
	song_player.stream = song;
	song_player.play();
	song_player.set_stream_paused(true);

func _physics_process(delta):
	if Input.is_action_just_pressed("Editor - Play or Pause"):
		on_play_or_pause();
	
	if song_player.playing and camera_follow_song_bar:
		camera.global_position.y -= song_progress_line_speed*delta;

func change_spaces_per_beat(change_multiplier : float):
	if (grid_spaces_per_beat*change_multiplier >= 1):
		print("new spaces per beat: " + str(grid_spaces_per_beat*change_multiplier));
		
		song_player.set_stream_paused(true);
		song_progress_line.velocity.y = 0;
		
		grid_spaces_per_beat *= change_multiplier;
		for note in note_parent.get_children():
			var current_grid_position = grid.get_grid_position(note.global_position);
			var new_position = (((current_grid_position.y)*change_multiplier)*grid.SPACE_SIZE.y);
			note.global_position.y = (new_position);
		
		song_progress_line_speed = grid.SPACE_SIZE.y*beats_per_second*grid_spaces_per_beat
		song_progress_line.global_position.y *= change_multiplier;
		
		var cursor_grid_position = grid.get_grid_position(cursor.global_position);
		var new_cursor_grid_position = cursor_grid_position;
		
		new_cursor_grid_position.y *= change_multiplier;
		
		var camera_offset_y = (new_cursor_grid_position.y - cursor_grid_position.y)*grid.SPACE_SIZE.y;
		
		camera.global_position.y += camera_offset_y;
		
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
