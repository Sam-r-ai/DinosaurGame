extends AnimatedSprite2D

@export var anim : AnimationPlayer;

@export var left_point : float;
@export var right_point : float;

var in_frame = false;
var fly_anim_finished = false;

func fly_in():
	print("flying in");
	frame = 0;
	anim.play("fly in");
	in_frame = true;

func fly_out():
	fly_anim_finished = false;
	print("flying out");
	anim.play("fly out");
	in_frame = false;

func toggle():
	if in_frame == true:
		print("in frame = true");
		fly_out();
	else:
		fly_in();

func _on_animation_player_animation_finished(anim_name):
	print("animation finished");
	fly_anim_finished = true;
