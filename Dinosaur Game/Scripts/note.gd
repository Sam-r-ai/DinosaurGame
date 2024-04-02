extends Area2D;

class_name ChartNote;

@export var anim : AnimatedSprite2D;

var lane : int;
var timestamp : float;

func on_hit():
	anim.play("hit");

func reset():
	anim.play("default");
