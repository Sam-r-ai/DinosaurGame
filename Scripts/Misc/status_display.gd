extends Label

class_name StatusDisplay;

@export var anim : AnimationPlayer;
@export var timer : Timer;

func _ready():
	self_modulate = Color(1,1,1,0);

func display_message(message : String, color : Color = Color(1,1,1)):
	anim.play("RESET");
	text = message;
	timer.start();
	
	modulate = color;

func fade_out():
	anim.play("fade out");
