extends Area2D

@export var game : Game;

func on_trigger_enter(trigger):
		if trigger is StartTrigger:
			game.chart.song_player.play();

