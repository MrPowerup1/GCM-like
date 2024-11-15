extends Resource
class_name Input_Keys

@export var conversion:Dictionary = {
	"Left":"Left",
	"Right":"Right",
	"Up":"Up",
	"Down":"Down",
	"Melee":"Melee",
	"Mobility":"Mobility",
	"Spell1":"Spell1",
	"Spell2":"Spell2",
	"Select":"Select",
	"Back":"Back"
	#"Melee":"Melee",
	#"Dash":"Dash"
	}
	
enum device_type {KEYBOARD,JOYSTICK,REMOTE}
@export var device:device_type
@export var device_id:int
@export var icons:Dictionary = {
	"Melee":"res://Art/xbox_button_color_x.png",
	"Mobility":"res://Art/xbox_button_color_a.png",
	"Spell1":"res://Art/xbox_button_color_b.png",
	"Spell2":"res://Art/xbox_button_color_y.png"
}

func to_dict()->Dictionary:
	return {
		"conversion":conversion,
		"device_type":device,
		"device_id":device_id
	}

static func from_dict(keys_dict:Dictionary)->Input_Keys:
	var new_input = Input_Keys.new()
	new_input.conversion=keys_dict.get("conversion")
	new_input.device = keys_dict.get("device_type")
	new_input.device_id = keys_dict.get("device_id")
	if new_input.device == device_type.JOYSTICK:
		new_input.icons = {
			"Melee":"res://Art/xbox_button_color_x.png",
			"Mobility":"res://Art/xbox_button_color_a.png",
			"Spell1":"res://Art/xbox_button_color_b.png",
			"Spell2":"res://Art/xbox_button_color_y.png"
		}
	elif new_input.device == device_type.KEYBOARD:
		if new_input.device_id == -1:
			new_input.icons = {
				"Melee":"res://Art/keyboard_x.png",
				"Mobility":"res://Art/keyboard_z.png",
				"Spell1":"res://Art/keyboard_c.png",
				"Spell2":"res://Art/keyboard_v.png"
			}
		elif new_input.device_id == -2:
			new_input.icons = {
				"Melee":"res://Art/keyboard_m.png",
				"Mobility":"res://Art/keyboard_n.png",
				"Spell1":"res://Art/keyboard_comma.png",
				"Spell2":"res://Art/keyboard_period.png"
			}
	elif new_input.device_id == device_type.REMOTE:
		new_input.icons = {
			"Melee":"res://Art/flair_arrows_left.png",
			"Mobility":"res://Art/flair_arrows_down.png",
			"Spell1":"res://Art/flair_arrows_up.png",
			"Spell2":"res://Art/flair_arrows_right.png"
		}
	return new_input
