extends Node
class_name PlayerCharacterInput

@export var input_keys:Input_Keys
@export var character: CharacterBody2D
@export var velocity_component:Velocity

signal button_activate(index)
signal button_release(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Vector2(Input.get_axis(input_keys.left, input_keys.right),Input.get_axis(input_keys.up,input_keys.down))
	velocity_component.move_input(direction,delta)
	if (Input.is_action_just_pressed(input_keys.spell1)):
		button_activate.emit(0)
	if (Input.is_action_just_released(input_keys.spell1)):
		button_release.emit(0)
	if (Input.is_action_just_pressed(input_keys.spell2)):
		button_activate.emit(1)
	if (Input.is_action_just_released(input_keys.spell2)):
		button_release.emit(1)
	
