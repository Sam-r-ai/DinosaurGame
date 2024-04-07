extends Area2D

class_name NoteHoldBar;

@export var nine_patch : NinePatchRect;
@export var collision_shape : CollisionShape2D;

var length = 40;
var hold_time = 40;
var missed : bool = false;

func on_hit(catcher_position : Vector2, hit_amount : float):
	catcher_position.y += 40;
	var bottom_bound = global_position.y + nine_patch.size.y
	
	if bottom_bound > catcher_position.y:
		nine_patch.size.y -= abs(bottom_bound - catcher_position.y);
		missed = true;
	
	nine_patch.size.y -= hit_amount;
	hold_time -= hit_amount;
	
	if hold_time <= 0:
		print("hit the full note!");
		queue_free();
	
	if nine_patch.size.y <= 20 and missed:
		visible = false;
		print("missed some of the note");

func update_length(new_length):
	var length_difference = new_length - length;
	length = abs(new_length);
	nine_patch.size.y = length;
	collision_shape.shape.extents.y = nine_patch.size.y/2;
	collision_shape.global_position.y = global_position.y + length/2 - 20;
	
	hold_time = length;

func reset():
	pass;
