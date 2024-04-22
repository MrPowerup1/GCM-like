extends Node
class_name PlayerCharacterInput

@export var input_keys:Input_Keys
#@export var character: Node2D
@export var velocity:Velocity
@export var device_id:int
enum device_type {KEYBOARD,JOYSTICK}
@export var device:device_type
enum input_mode {UI,GAMEPLAY}
@export var current_mode:input_mode

signal button_activate(index:int)
signal button_release(index:int)
signal direction_pressed(direction:Vector2)
signal input_mode_changed(new_mode:input_mode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Vector2(Input.get_axis(input_keys.conversion["Left"], input_keys.conversion["Right"]),Input.get_axis(input_keys.conversion["Up"],input_keys.conversion["Down"]))
	if (velocity!=null and current_mode == input_mode.GAMEPLAY):
		velocity.move_input(direction,delta)
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


#print(Input.get_connected_joypads())
	
