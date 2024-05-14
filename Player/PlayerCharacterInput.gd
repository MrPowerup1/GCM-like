extends Node
class_name PlayerCharacterInput

@export var input_keys:Input_Keys
#@export var character: Node2D
@export var velocity:Velocity
#@export var device_id:int
enum device_type {LOCAL,REMOTE}
@export var device:device_type
enum input_mode {UI,GAMEPLAY}
@export var current_mode:input_mode

var fixed_zero_vector = SGFixedVector2.new()

signal button_activate(index:int)
signal button_release(index:int)
signal direction_pressed(direction:Vector2)
signal input_mode_changed(new_mode:input_mode)

func _ready():
	fixed_zero_vector.from_float(Vector2.ZERO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (device!=device_type.REMOTE and input_keys!=null):
		var direction = Input.get_vector(input_keys.conversion["Left"],input_keys.conversion["Right"],input_keys.conversion["Up"],input_keys.conversion["Down"])
		#if (velocity!=null and current_mode == input_mode.GAMEPLAY):
		#	velocity.move_input(direction)
		if (current_mode == input_mode.UI and direction != Vector2.ZERO):
			direction_pressed.emit(direction)
		if (Input.is_action_just_pressed(input_keys.conversion["Spell1"])):
			button_activate.emit(0)
		if (Input.is_action_just_released(input_keys.conversion["Spell1"])):
			button_release.emit(0)
		if (Input.is_action_just_pressed(input_keys.conversion["Spell2"])):
			button_activate.emit(1)
		if (Input.is_action_just_released(input_keys.conversion["Spell2"])):
			button_release.emit(1)

func _get_local_input() -> Dictionary:
	var input_vector = SGFixedVector2.new()
	input_vector.from_float(Input.get_vector(input_keys.conversion["Left"],input_keys.conversion["Right"],input_keys.conversion["Up"],input_keys.conversion["Down"]))
	var input = {}
	
	if input_vector != fixed_zero_vector:
		input["input_vector"]=input_vector
	
	return input

func _network_process(input: Dictionary) -> void:
	var move_vector = input.get("input_vector", fixed_zero_vector)
	velocity.move_input(move_vector)
	velocity.update_pos()
