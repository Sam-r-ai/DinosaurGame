extends Area2D;

class_name ChartNote;

@export var anim : AnimationPlayer;
@export var note_hold_bar_scene : PackedScene;
@export var color : AnimatedSprite2D;

var lane : int;
var timestamp : float;
var hold_time = 0;
var hold_bar;

func on_hit():
	anim.play("hit");

func reset():
	anim.play("RESET");

func create_hold_bar():
	if !hold_bar:
		hold_bar = note_hold_bar_scene.instantiate();
		add_child(hold_bar);
	
	
