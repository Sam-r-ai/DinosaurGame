extends Area2D

class_name TriggerReciever;

@export var play_mode : PlayMode;

func on_trigger_enter(trigger):
	print("trigger entered");
	print("trigger function: " + str(trigger.function));
	trigger.queue_free();
	
	match trigger.function:
		"toggle closeup":
			play_mode.dino_close_up.toggle();

func _on_area_entered(area):
	if area is Trigger:
		on_trigger_enter(area);

