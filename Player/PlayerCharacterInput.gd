extends Node
class_name PlayerCharacterInput

@export var input_keys:Input_Keys
#@export var character: Node2D
@export var velocity:Velocity
#@export var device_id:int
enum device_type {LOCAL,REMOTE}
@export var device:device_type
const straight_fixed:int = 65536
const diag_fixed:int = 46341
var fixed_zero_vector = SGFixed.vector2(0,0)

signal button_activate(index:int)
signal button_release(index:int)
signal direction_pressed(direction:Vector2)


func _get_local_input() -> Dictionary:
	var input = {}
	
	#Doesn't work because of floats
	#var input_vector = SGFixedVector2.new()
	#input_vector.from_float(Input.get_vector(input_keys.conversion["Left"],input_keys.conversion["Right"],input_keys.conversion["Up"],input_keys.conversion["Down"]))
	
	var input_vector = input_axis()
	
	if (Input.is_action_just_pressed(input_keys.conversion["Spell1"])):
		input['spell_1_pressed']=true
	if (Input.is_action_just_released(input_keys.conversion["Spell1"])):
		input['spell_1_released']=true
	if (Input.is_action_just_pressed(input_keys.conversion["Spell2"])):
		input['spell_2_pressed']=true
	if (Input.is_action_just_released(input_keys.conversion["Spell2"])):
		input['spell_2_released']=true
	if (Input.is_action_just_pressed(input_keys.conversion["Melee"])):
		input['melee_pressed']=true
	if (Input.is_action_just_released(input_keys.conversion["Melee"])):
		input['melee_released']=true
	if (Input.is_action_just_pressed(input_keys.conversion["Mobility"])):
		input['mobility_pressed']=true
	if (Input.is_action_just_released(input_keys.conversion["Mobility"])):
		input['mobility_released']=true
	if not input_vector.is_equal_approx(fixed_zero_vector):
		input['input_vector']=input_vector	
	return input

func input_axis() -> SGFixedVector2:
	var horizontal_sum = 0
	var vertical_sum = 0
	if Input.is_action_pressed(input_keys.conversion["Left"]):
		horizontal_sum -=1
	if Input.is_action_pressed(input_keys.conversion["Right"]):
		horizontal_sum +=1
	if Input.is_action_pressed(input_keys.conversion["Up"]):
		vertical_sum -=1
	if Input.is_action_pressed(input_keys.conversion["Down"]):
		vertical_sum +=1

	if horizontal_sum !=0:
		if vertical_sum == 0:
			return SGFixed.vector2(horizontal_sum*straight_fixed,0)
		else:
			return SGFixed.vector2(horizontal_sum*diag_fixed,vertical_sum*diag_fixed)
	elif vertical_sum !=0:
		return SGFixed.vector2(0,vertical_sum*straight_fixed)
	else:
		return SGFixed.vector2(0,0)

func _network_postprocess(input: Dictionary) -> void:
	var move_vector = input.get('input_vector',fixed_zero_vector) #SGFixed.vector2(input.get('input_vector_x', 0),input.get('input_vector_y', 0))
	velocity.move_input(move_vector)
	if input.get('spell_1_pressed',false):
		button_activate.emit(0)
	if input.get('spell_1_released',false):
		button_release.emit(0)
	if input.get('spell_2_pressed',false):
		button_activate.emit(1)
	if input.get('spell_2_released',false):
		button_release.emit(1)
	if input.get('melee_pressed',false):
		button_activate.emit(2)
	if input.get('melee_released',false):
		button_release.emit(2)
	if input.get('mobility_pressed',false):
		button_activate.emit(3)
	if input.get('mobility_released',false):
		button_release.emit(3)

func _predict_remote_input(previous_input:Dictionary, ticks_since_last_input: int) -> Dictionary:
	var input = previous_input.duplicate()
	input.erase('spell_1_pressed')
	input.erase('spell_1_released')
	input.erase('spell_2_pressed')
	input.erase('spell_2_released')
	input.erase('melee_pressed')
	input.erase('melee_released')
	input.erase('mobility_pressed')
	input.erase('mobility_released')
	return input
	

func reset_velocity_reference():
	velocity = %Velocity
