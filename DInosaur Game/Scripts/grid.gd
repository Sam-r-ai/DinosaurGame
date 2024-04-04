extends Node2D

class_name Grid;

const SPACE_SIZE = Vector2(160,40);

var grid_position = Vector2(0,0);
var size = Vector2(6,18);

@export var chart_editor : ChartEditor;

@onready var camera_offset = global_position - chart_editor.camera.global_position;

func _physics_process(delta):
	grid_position.y = get_position_aligned_to_grid(chart_editor.camera.global_position-camera_offset).y;
	queue_redraw();

func _draw():
	draw_grid(grid_position, Color(1,1,1));

func draw_grid(position : Vector2, color : Color):
	position.y -= 40;
	var columns = size.x;
	var rows = size.y;
	
	for column in columns+1:
		var column_position = position;
		column_position.x += column*SPACE_SIZE.x;
		
		var column_end_position = column_position;
		column_end_position.y += rows*SPACE_SIZE.y;
		
		draw_line(column_position, column_end_position, color);
		
	for row in rows+1:
		var row_position = position;
		row_position.y += row*SPACE_SIZE.y;
		
		var row_end_position = row_position;
		row_end_position.x += columns*SPACE_SIZE.x;
		
		draw_line(row_position, row_end_position, color);

func get_position_aligned_to_grid(position : Vector2):
	var return_position : Vector2;
	return_position.x = floor(position.x/SPACE_SIZE.x)*SPACE_SIZE.x;
	return_position.y = ceil(position.y/SPACE_SIZE.y)*SPACE_SIZE.y;
	return return_position;

func get_grid_position(position : Vector2):
	var return_position : Vector2;
	return_position.x = (position.x/SPACE_SIZE.x);
	return_position.y = (position.y/SPACE_SIZE.y);
	return return_position;
