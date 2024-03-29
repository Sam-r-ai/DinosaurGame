extends CharacterBody2D

class_name Note;

@export var game: Game;

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(0,game.note_speed);

func _physics_process(delta):
	move_and_slide();
