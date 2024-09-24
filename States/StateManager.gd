extends Node
class_name StateManager


@export var starting_state:State
var current_state:State
var current_state_name:String
var states:Dictionary = {}
var current_state_process:bool = true
var current_state_physics_process:bool = true
var current_state_network_process:bool = true


func set_processes():
	current_state_physics_process= current_state.do_physics_process
	current_state_process= current_state.do_process
	current_state_network_process= current_state.do_network_process

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			(child as State).Transition.connect(on_transition)
	if starting_state:
		current_state=starting_state
		current_state_name=states.find_key(current_state)
		current_state.enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state and current_state_process:
		if current_state_name != states.find_key(current_state):
			current_state=states[current_state_name]
		current_state.process(delta)

func _physics_process(delta):
	if current_state and current_state_physics_process:
		current_state.physics_process(delta)

func _network_process(input:Dictionary)->void:
	if current_state and current_state_network_process:
		current_state.network_process(input)
func on_transition(state,new_state_name):
	if state!=current_state:
		print("Trying to transition from a state that you aren't in")
		return
	var new_state = states[new_state_name.to_lower()]
	if !new_state:
		print("Trying to transition to a state that doesnt exist")
		return
	if current_state:
		current_state.exit()
	current_state_name = new_state_name.to_lower()
	new_state.enter()
	current_state=new_state
