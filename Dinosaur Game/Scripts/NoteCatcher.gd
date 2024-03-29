extends Area2D

class_name NoteCatcher;

@export var input_action : String;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed(input_action):
		if get_overlapping_note():
			var note = get_overlapping_note()
			note.queue_free();
			print("note hit!");

func get_overlapping_note():
	if has_overlapping_bodies():
			var overlapping_bodies = get_overlapping_bodies();
			for body in overlapping_bodies:
				if body is ChartNote:
					return body;
			return null;
