extends Resource
class_name Input_Keys

@export var conversion:Dictionary = {
	"Left":"Left",
	"Right":"Right",
	"Up":"Up",
	"Down":"Down",
	"Spell1":"Spell1",
	"Spell2":"Spell2"
	}
	
enum device_type {KEYBOARD,JOYSTICK}
@export var device:device_type
@export var device_id:int

func to_dict()->Dictionary:
	return {
		"conversion":conversion,
		"device_type":device,
		"device_id":device_id
	}

static func from_dict(keys_dict:Dictionary)->Input_Keys:
	var new_input = Input_Keys.new()
	#print(keys_dict)
	#print(keys_dict.get("conversion"))
	new_input.conversion=keys_dict.get("conversion")
	new_input.device = keys_dict.get("device_type")
	new_input.device_id = keys_dict.get("device_id")
	return new_input
