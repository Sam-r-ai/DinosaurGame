extends State

@onready var cursor : Cursor = get_parent().parent;

@export var mode_display : Label;

func enter_state():
	cursor.can_scroll = true;
	cursor.can_zoom = true;
	
	mode_display.text = "Normal";

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
		
		if Input.is_action_pressed("Right Click"):
			var note = cursor.get_overlapping_note();
			if note:
				note.queue_free();
				
			var trigger = cursor.get_overlapping_trigger();
			if trigger:
				trigger.queue_free();
		
	
	if Input.is_action_pressed("Editor - Paste"):
		change_state.emit(self, "Paste");

func _on_select_button_ui_button_pressed(button):
	if get_parent().current_state == self:
		change_state.emit(self, button.text);
