extends Control

@export var play_mode : PlayMode;

@export var score_display : Label;
@export var miss_display : Label;
@export var accuracy_display : Label;
@export var rank_display : RankDisplay;

func initialize():
	var score = play_mode.score;
	var max_score = play_mode.max_score;
	
	score_display.text = "Score: " + str(play_mode.score);
	miss_display.text = "Misses: " + str(play_mode.misses);
	accuracy_display.text = "Accuracy: " + str(play_mode.accuracy);
	
	if score > max_score * 0.6:
		rank_display.rank_index = 1;
	if score > max_score * 0.7:
		rank_display.rank_index = 2;
	if score > max_score * 0.8:
		rank_display.rank_index = 3;
	if score > max_score * 0.9:
		rank_display.rank_index = 4;
	if score > max_score * 0.95:
		rank_display.rank_index = 5;
	
	rank_display.update_rank();
	
	print(str(score) + "/" + str(max_score));
	print(rank_display.rank_index);
	
	
