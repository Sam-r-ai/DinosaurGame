extends AnimatedSprite2D

@export var anim : AnimationPlayer;

@export var left_point : float;
@export var right_point : float;

func _ready():
	fly_in();

func fly_in():
	anim.play("fly in");

func fly_out():
	frame = 0;
	anim.play("fly out");
