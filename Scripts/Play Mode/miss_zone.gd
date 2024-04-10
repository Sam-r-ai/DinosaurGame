extends Area2D

@export var play_mode : PlayMode;
@export var miss_display : Label;

func _on_area_entered(area):
	if area is ChartNote:
		if !area.hit:
			play_mode.misses += 1;
			miss_display.text = "Misses: " + str(play_mode.misses);
