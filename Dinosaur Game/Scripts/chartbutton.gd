extends Button

var assigned_chart : String;
var chart_path : String;
var scene_path : String;


func _on_pressed():
	print("Assigned Chart: " + assigned_chart);
	if (chart_path):
		ChartData.chart_path = chart_path;
		get_tree().change_scene_to_file(scene_path);
	else:
		print("chart path null");
