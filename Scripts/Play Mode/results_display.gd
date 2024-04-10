extends Control

@export var play_mode : PlayMode;

@export var score_display : Label;
@export var miss_display : Label;
@export var accuracy_display : Label;
@export var rank_display : RankDisplay;

var score : int = 0;
var misses : int = 0;
var max_score : int = 0;

var display_score = 0;
var display_misses = 0;

var initialized : bool = false;

func initialize():
	score = play_mode.score;
	misses = play_mode.misses;
	max_score = play_mode.max_score;
	
	score_display.text = "Score: 0";
	miss_display.text = "Misses: 0";
	accuracy_display.text = "Accuracy: -"
	
	print(str(score) + "/" + str(max_score));
	print(rank_display.rank_index);
	initialized = true;

func _physics_process(delta):
	if initialized:
		display_score = move_toward(display_score, score, score/300);
		display_misses = move_toward(display_misses, misses, misses/300);
		
		score_display.text = "Score: " + str(display_score);
		miss_display.text = "Misses: " + str(display_misses);
		accuracy_display.text = "Accuracy: " + str(play_mode.accuracy);
		
		if display_score > max_score * 0.6:
			rank_display.rank_index = 1;
		if display_score > max_score * 0.7:
			rank_display.rank_index = 2;
		if display_score > max_score * 0.8:
			rank_display.rank_index = 3;
		if display_score > max_score * 0.9:
			rank_display.rank_index = 4;
		if display_score > max_score * 0.95:
			rank_display.rank_index = 5;
		
		rank_display.update_rank();
