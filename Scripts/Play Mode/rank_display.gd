extends AnimatedSprite2D

class_name RankDisplay;

@export var rank_index : int;
@export var anim : AnimationPlayer;
@export var s_outline : Sprite2D;

var s_color : Color = Color(1,1,1);

func _ready():
	update_rank();

func _physics_process(delta):
	if rank_index == 5 and !anim.is_playing():
		s_outline.visible = true;
		anim.play("rainbow");
	elif rank_index != 5 and anim.is_playing():
		s_outline.visible = false;
		anim.play("RESET");

func update_rank():
	frame = rank_index;
