extends Area2D

class_name NoteHoldBar;

@export var nine_patch : NinePatchRect;
@export var collision_shape : CollisionShape2D;

var length = 40;

func update_length(new_length):
	length = abs(new_length);
	nine_patch.size.y = length;
	collision_shape.shape.get_rect().size.y = length;

func reset():
	pass;
