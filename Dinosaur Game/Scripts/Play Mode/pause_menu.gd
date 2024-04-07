extends Control

signal quit_button_pressed;
signal previous_scene_button_pressed;
signal edit_button_pressed;
signal restart_button_pressed;

@export var button_panel : Panel;
@export var resume_timer : Timer;
@export var resume_time_meter : ProgressBar;

func _ready():
	visible = false;

func _physics_process(delta):
	resume_time_meter.value = resume_timer.time_left;
	resume_time_meter.label.text = "Resuming in " + str(round(resume_timer.time_left)) + "...";

func _on_resume_btn_pressed():
	#visible = false;
	button_panel.visible = false;
	resume_time_meter.visible = true;
	release_focus();
	resume_timer.start();

func _on_previous_scene_btn_pressed():
	release_focus();
	get_tree().paused = false;
	previous_scene_button_pressed.emit();

func _on_quit_btn_pressed():
	release_focus();
	get_tree().paused = false;
	quit_button_pressed.emit();

func on_resume_timer_timeout():
	button_panel.visible = true;
	resume_time_meter.visible = false;
	visible = false;
	get_tree().paused = false;

func _on_edit_btn_pressed():
	release_focus();
	get_tree().paused = false;
	edit_button_pressed.emit();

func _on_restart_btn_pressed():
	release_focus();
	get_tree().paused = false;
	restart_button_pressed.emit();
