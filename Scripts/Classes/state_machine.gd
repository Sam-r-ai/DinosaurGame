extends Node

class_name StateMachine;

@export var initial_state: State;
@export var print_state : bool;

@export var parent : Node;

var states: Dictionary = {};
var current_state: State;

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child;
			child.change_state.connect(on_change_state);
	
	if initial_state:
		initial_state.enter_state();
		current_state = initial_state;

func _process(delta):
	if current_state:
		current_state.state_process(delta);

func _physics_process(delta):
	if current_state:
		current_state.state_physics_process(delta);

func on_change_state(state, new_state_name):
	if state != current_state:
		return;
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return;
	
	if current_state:
		current_state.exit_state();
	
	new_state.enter_state();
	
	current_state = new_state;
	if (print_state):
		print("Changing State to " + str(current_state));
