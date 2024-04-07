extends State

@onready var cursor : Cursor = get_parent().parent;

func enter_state():
	cursor.can_scroll = true;
	cursor.can_zoom = true;

func state_physics_process(delta):
	cursor.move();
	cursor.can_set_song_progress();
	
	if cursor.is_mouse_in_range():
		if Input.is_action_just_pressed("Left Click"):
			var note = cursor.get_overlapping_note();
			if !note:
				change_state.emit(self, "Placing Note");
				return;
			else:
				print(note.lane);
				print(note.timestamp);
				print(note.hold_time);
		
		if Input.is_action_just_pressed("Right Click"):
			var note = cursor.get_overlapping_note();
			if note:
				note.queue_free();
			var held_note = cursor.get_overlapping_held_note();
			if held_note:
				held_note.queue_free();
		

func _on_select_button_ui_button_pressed(button):
	if get_parent().current_state == self:
		change_state.emit(self, button.text);
