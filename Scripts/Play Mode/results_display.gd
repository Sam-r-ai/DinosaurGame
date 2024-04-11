extends Control

@export var play_mode : PlayMode;

@export var score_display : Label;
@export var miss_display : Label;
@export var accuracy_display : Label;
@export var rank_display : RankDisplay;

var initialized = false;

var score_count = 0;
var miss_count = 0;

var score = 0;
var max_score = 0;

func initialize():
	score = play_mode.score;
	max_score = play_mode.max_score;
	
	accuracy_display.text = "Accuracy: " + str(play_mode.accuracy);
	initialized = true;

func _physics_process(delta):
	if initialized:
		score_count = move_toward(score_count, play_mode.score, 100);
		miss_count = move_toward(miss_count, play_mode.misses, 1);
		
		score_display.text = "Score: " + str(score_count);
		miss_display.text = "Misses: " + str(miss_count);
		
		if score_count > max_score * 0.6:
			rank_display.rank_index = 1;
		if score_count > max_score * 0.7:
			rank_display.rank_index = 2;
		if score_count > max_score * 0.8:
			rank_display.rank_index = 3;
		if score_count > max_score * 0.9:
			rank_display.rank_index = 4;
		if score_count > max_score * 0.95 and play_mode.misses < 1:
			rank_display.rank_index = 5;
		
		rank_display.update_rank();
