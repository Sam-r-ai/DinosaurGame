extends CharacterBody2D

class_name ChartNote;

var game: Game;

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent().game;
	velocity = Vector2(0,game.note_speed);

func _physics_process(delta):
	move_and_slide();
