extends Area2D

@onready var anim_player =  $AnimationPlayer;

@onready var play_mode : PlayMode = get_parent();

@export_range (0, 5) var lane;
@export var pixels_per_second = 600;

@onready var catcher_size = 80;

func _physics_process(delta):
	#Hit Notes
	if Input.is_action_just_pressed("Note " + str(lane)):
		var lowest_note = get_lowest_note();
		if lowest_note:
			var inaccuracy = abs((global_position.y) - lowest_note.global_position.y);
			var score_multiplier = 1 - (inaccuracy/catcher_size);
			
			print(score_multiplier);
			
			hit_note(lowest_note);
			play_mode.score += 100*score_multiplier;
			play_mode.update_score_display();
	
	#Hit Held Notes
	if Input.is_action_pressed("Note " + str(lane)):
		var held_note = get_held_note();
		
		if held_note:
			
			held_note.on_hit(global_position, delta*pixels_per_second);
			play_mode.score += round(100 * delta);
			play_mode.update_score_display();

func hit_note(note):
	note.on_hit();
	anim_player.play("hit");

func hit_held_note(held_note):
	held_note.on_hit();
	pass;

func get_lowest_note():
	var overlapping_areas = get_overlapping_areas();
	
	var lowest_note : ChartNote;
	var lowest_note_position = 1000;
	
	for area in overlapping_areas:
		if area is ChartNote:
			if (area.global_position.y < lowest_note_position) and (area.lane == lane):
				lowest_note = area;
				lowest_note_position = lowest_note.global_position.y;
	
	return lowest_note;

func get_held_note():
	var overlapping_areas = get_overlapping_areas();
	
	var held_note : NoteHoldBar;
	
	for area in overlapping_areas:
		if area is NoteHoldBar:
			held_note = area;
	
	return held_note;
