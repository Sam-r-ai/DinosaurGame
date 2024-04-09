extends Node2D

class_name SongChart;

@export var bpm : float;
@export var pixels_per_beat : float = 160;
@export var chart_scroll_speed : float = 200;

@export var game : Game;
@export var song_player : AudioStreamPlayer;
@export var track : CharacterBody2D;
@export var note_parent : Node2D;


# Called when the node enters the scene tree for the first time.
func _ready():
	var seconds_per_beat : float = 60/bpm;
	print("bpm: " + str(bpm));
	track.velocity.y = chart_scroll_speed;
	
	for note in note_parent.get_children():
		note.global_position.y *= seconds_per_beat*chart_scroll_speed/pixels_per_beat;
