extends Node
class_name PlayerUIInput

var player_index:int
@export var input_keys:Input_Keys
#enum device_type {LOCAL,REMOTE}
#@export var device:device_type
var taking_inputs = true

signal button_activate(index:int)
signal button_release(index:int)
signal direction_pressed(direction:Vector2)

func _input(event):
	if input_keys !=null and taking_inputs:
		var direction: Vector2 =Vector2.ZERO
		if (event.is_action_pressed(input_keys.conversion["Left"])):
			direction.x-=1
			get_viewport().set_input_as_handled()
		if (event.is_action_pressed(input_keys.conversion["Right"])):
			direction.x+=1
			get_viewport().set_input_as_handled()
		if (event.is_action_pressed(input_keys.conversion["Up"])):
			direction.y-=1
			get_viewport().set_input_as_handled()
		if (event.is_action_pressed(input_keys.conversion["Down"])):
			direction.y+=1
			get_viewport().set_input_as_handled()
		if (not direction.is_zero_approx()):
			direction_pressed.emit(direction)
		if (event.is_action_pressed(input_keys.conversion["Spell1"])):
			button_activate.emit(0)
			get_viewport().set_input_as_handled()
		if (event.is_action_released(input_keys.conversion["Spell1"])):
			button_release.emit(0)
			get_viewport().set_input_as_handled()
		if (event.is_action_pressed(input_keys.conversion["Spell2"])):
			button_activate.emit(1)
			get_viewport().set_input_as_handled()
		if (event.is_action_released(input_keys.conversion["Spell2"])):
			button_release.emit(1)
			get_viewport().set_input_as_handled()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.		
#func _physics_process(delta):
	#if input_keys !=null and taking_inputs:
		#var direction = Input.get_vector(input_keys.conversion["Left"],input_keys.conversion["Right"],input_keys.conversion["Up"],input_keys.conversion["Down"])
		#if (not direction.is_zero_approx()):
			#direction_pressed.emit(direction)
		#if (Input.is_action_just_pressed(input_keys.conversion["Spell1"])):
			#button_activate.emit(0)
		#if (Input.is_action_just_released(input_keys.conversion["Spell1"])):
			#button_release.emit(0)
		#if (Input.is_action_just_pressed(input_keys.conversion["Spell2"])):
			#button_activate.emit(1)
		#if (Input.is_action_just_released(input_keys.conversion["Spell2"])):
			#button_release.emit(1)
