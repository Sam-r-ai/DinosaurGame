extends Node2D

class_name Game;

@export var note_speed : float = 1;

@export var chart : SongChart;

func _ready():
	var bpm = chart.bpm;
	var seconds_per_beat = bpm/60;
