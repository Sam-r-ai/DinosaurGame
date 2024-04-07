extends Control

@export var cursor_mode_label : Label;

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Button:
			child.ui_button_pressed.connect(set_cursor_mode_display);

func set_cursor_mode_display(button : Button):
	cursor_mode_label.text = button.text;
