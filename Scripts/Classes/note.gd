extends Area2D;

class_name ChartNote;

signal note_hit;

@export var anim : AnimationPlayer;
@export var color : AnimatedSprite2D;

var held_note : NoteHoldBar;

var lane : int;
var timestamp : float;
var hold_time = 0;
var hold_bar;
var hit : bool = false;
var type : int = 1;

func on_hit():
	hit = true;
	note_hit.emit();
	visible = false;

func reset():
	anim.play("RESET");
	visible = true;

