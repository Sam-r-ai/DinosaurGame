extends Button

signal chart_selected(path);

var assigned_chart : String;
var chart_path : String;

func _on_pressed():
	print("chart select emitted");
	chart_selected.emit(chart_path);
