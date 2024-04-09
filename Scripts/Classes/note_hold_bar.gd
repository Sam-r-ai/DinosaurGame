extends Area2D

class_name NoteHoldBar;

var parent_note : ChartNote;
@export var nine_patch : NinePatchRect;
@export var collision_shape : CollisionShape2D;
@export var end_point : Node2D;

var length = 40;
var hold_time = 40;
var missed : bool = false;

func on_hit(catcher_position : Vector2, hit_amount : float):
	catcher_position.y += 0;
	end_point.global_position.y = catcher_position.y;
	
	stretch_to_end_point();
	
	if global_position.y >= end_point.global_position.y:
		queue_free();

func update_length(new_length):
	var length_difference = new_length - length;
	length = abs(new_length);
	nine_patch.size.y = length;
	collision_shape.shape.extents.y = nine_patch.size.y/2;
	collision_shape.global_position.y = global_position.y + length/2;
	
	hold_time = length;

func stretch_to_end_point():
	var length = end_point.global_position.y - global_position.y;
	nine_patch.size.y = length
	collision_shape.shape.extents.y = nine_patch.size.y/2;
	collision_shape.global_position.y = global_position.y + length/2;

func reset():
	pass;
