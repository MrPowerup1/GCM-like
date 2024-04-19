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
	
enum device_type {keyboard,joystick}
@export var device:device_type
