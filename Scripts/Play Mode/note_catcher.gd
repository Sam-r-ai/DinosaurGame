extends Area2D

@onready var anim_player =  $AnimationPlayer;
@onready var parent = get_parent();
@onready var play_mode : PlayMode = parent.play_mode;
@onready var dino : DinoCharacter = play_mode.dino;
@onready var dino_close_up = play_mode.dino_close_up;

@export_range (0, 5) var lane;
@export var pixels_per_second = 600;
@export var hit_particle_scene : PackedScene;
@export var hit_particle_emitter : GPUParticles2D;

@onready var catcher_size = 80;

@onready var bot_play_active = play_mode.bot_play_active;

func _physics_process(delta):
	#Hit Notes
	if Input.is_action_just_pressed("Note " + str(lane)):
		var lowest_note = get_lowest_note();
		if lowest_note:
			hit_note(lowest_note);
	
	#Hit Held Notes
	if Input.is_action_pressed("Note " + str(lane)):
		var held_note = get_held_note();
		
		if held_note:
			held_note.on_hit(global_position, delta*pixels_per_second);
			play_mode.score += round(50 * delta);
			play_mode.update_score_display();
			if !hit_particle_emitter.emitting:
				hit_particle_emitter.emitting = true;
	
	if bot_play_active:
		var note = get_lowest_note();
		if note and note.global_position.y >= global_position.y-20:
			hit_note(note);
		
		var held_note = get_held_note();
		if held_note:
			held_note.on_hit(global_position, delta*pixels_per_second);
			play_mode.score += round(50 * delta);
			play_mode.update_score_display();
			if !hit_particle_emitter.emitting:
				hit_particle_emitter.emitting = true;

func hit_note(note : ChartNote):
	var inaccuracy = abs((global_position.y) - note.global_position.y);
	var score_multiplier = 1 - (inaccuracy/catcher_size);
	
	note.on_hit();
	anim_player.play("hit");
	var new_hit_particle = hit_particle_scene.instantiate();
	add_child(new_hit_particle);
	new_hit_particle.emitting = true;
	
	play_mode.score += 50*score_multiplier;
	play_mode.update_score_display();
	
	dino.anim.play("note_hit");
	dino.anim.seek(0);
	dino_close_up.frame = lane;
	if dino_close_up.fly_anim_finished:
		dino_close_up.anim.play("note_hit");
		dino_close_up.anim.seek(0);

func hit_held_note(held_note):
	held_note.on_hit();
	pass;

func get_lowest_note():
	var overlapping_areas = get_overlapping_areas();
	
	var lowest_note : ChartNote;
	var lowest_note_position = 1000;
	
	for area in overlapping_areas:
		if area is ChartNote:
			if (area.global_position.y < lowest_note_position) and (area.lane == lane) and (!area.hit):
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
