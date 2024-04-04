extends Button

signal chart_selected(path);

var assigned_chart : String;
var chart_path : String;

func _on_pressed():
	chart_selected.emit(chart_path);
