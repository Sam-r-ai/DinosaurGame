extends Area2D

class_name NoteCatcher;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("Note 1"):
		if has_overlapping_bodies():
			var overlapping_bodies = get_overlapping_bodies();
			for body in overlapping_bodies:
				if body is Note:
					print("note hit!");
					body.queue_free();
