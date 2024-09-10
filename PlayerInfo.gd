extends HBoxContainer
@export var keyboard:Texture2D
@export var joystick:Texture2D
@export var remote:Texture2D
@export var player_index_label:Label
@export var player_control_texture:TextureRect
var player_index:int:
	set(new_index):
		player_index_label.text=str(new_index)
var player_name:String
enum device_type {KEYBOARD,JOYSTICK,REMOTE}
@export var device:device_type:
	set(new_control):
		if new_control==device_type.KEYBOARD:
			player_control_texture.texture=keyboard
		if new_control==device_type.JOYSTICK:
			player_control_texture.texture=joystick
		if new_control==device_type.REMOTE:
			player_control_texture.texture=remote
