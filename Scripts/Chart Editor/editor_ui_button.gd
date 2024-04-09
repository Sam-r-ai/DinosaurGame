extends Button

signal ui_button_pressed(button : Button);

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(on_pressed);

func on_pressed():
	release_focus();
	ui_button_pressed.emit(self);
