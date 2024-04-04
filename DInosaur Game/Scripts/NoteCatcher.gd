extends Area2D

class_name NoteCatcher;

@export var input_action : String;


func _physics_process(delta):
	var overlapping_note = get_overlapping_note();
	
	if overlapping_note and Input.is_action_just_pressed(input_action):
		overlapping_note.queue_free();

func get_overlapping_note():
	if has_overlapping_areas():
			var overlapping_areas = get_overlapping_areas();
			for area in overlapping_areas:
				if area is ChartNote:
					return area;
			return null;
