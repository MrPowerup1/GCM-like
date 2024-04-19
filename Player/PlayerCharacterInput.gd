extends Node
class_name PlayerCharacterInput

@export var input_keys:Input_Keys
#@export var character: Node2D
@export var velocity_component:Velocity
@export var device_id:int
enum device_type {keyboard,joystick}
@export var device:device_type

signal button_activate(index)
signal button_release(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Vector2(Input.get_axis(input_keys.conversion["Left"], input_keys.conversion["Right"]),Input.get_axis(input_keys.conversion["Up"],input_keys.conversion["Down"]))
	velocity_component.move_input(direction,delta)
	if velocity_component.can_move:
		print(direction)
		print (velocity_component.speed)
	if (Input.is_action_just_pressed(input_keys.conversion["Spell1"])):
		button_activate.emit(0)
	if (Input.is_action_just_released(input_keys.conversion["Spell1"])):
		button_release.emit(0)
	if (Input.is_action_just_pressed(input_keys.conversion["Spell2"])):
		button_activate.emit(1)
	if (Input.is_action_just_released(input_keys.conversion["Spell2"])):
		button_release.emit(1)


#print(Input.get_connected_joypads())
	
