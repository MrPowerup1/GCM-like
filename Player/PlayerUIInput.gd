extends Node
class_name PlayerUIInput

var player_index:int
@export var input_keys:Input_Keys
enum device_type {LOCAL,REMOTE}
@export var device:device_type

signal button_activate(index:int)
signal button_release(index:int)
signal direction_pressed(direction:Vector2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if input_keys !=null:
		var direction = Input.get_vector(input_keys.conversion["Left"],input_keys.conversion["Right"],input_keys.conversion["Up"],input_keys.conversion["Down"])
		if (not direction.is_zero_approx()):
			direction_pressed.emit(direction)
		if (Input.is_action_just_pressed(input_keys.conversion["Spell1"])):
			button_activate.emit(0)
		if (Input.is_action_just_released(input_keys.conversion["Spell1"])):
			button_release.emit(0)
		if (Input.is_action_just_pressed(input_keys.conversion["Spell2"])):
			button_activate.emit(1)
		if (Input.is_action_just_released(input_keys.conversion["Spell2"])):
			button_release.emit(1)
