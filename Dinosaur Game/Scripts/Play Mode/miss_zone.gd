extends Area2D

@export var miss_display : Label;

var misses : int = 0;

func _on_area_entered(area):
	if area is ChartNote:
		if !area.hit:
			misses += 1;
			miss_display.text = "Misses: " + str(misses);
