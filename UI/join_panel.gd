extends PanelContainer

var animator:AnimationPlayer
@export var base_action_strings:Array[String]=[]
var device_keys={Input_Keys.device_type.KEYBOARD:"kb",Input_Keys.device_type.JOYSTICK:"joy"}
@export var keyboard_input_1:Input_Keys
@export var keyboard_input_2:Input_Keys
var accepting_input:bool =true

signal player_joined(input:Input_Keys)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	%AnimationPlayer.play("Animate Join Sprite")

signal next()
@rpc("any_peer","call_local")
func left():
	pass
@rpc("any_peer","call_local")
func right():
	pass
@rpc("any_peer","call_local")
func up():
	pass
@rpc("any_peer","call_local")
func down():
	pass
@rpc("any_peer","call_local")
func select():
	next.emit()
@rpc("any_peer","call_local")
func back():
	pass


func new_player(input:Input_Keys):
	player_joined.emit(input)
	next.emit()
	accepting_input=false

func _unhandled_input(event):
	if accepting_input:
		var id = event.device
		var type=Input_Keys.device_type.JOYSTICK
		if event.is_action_pressed("Join_joy_1"):
			var new_keys=_duplicate_input(id,type)
			new_player(new_keys)
		type=Input_Keys.device_type.KEYBOARD
		if event.is_action_pressed("Join_kb_1"):
			new_player(keyboard_input_1)
		if event.is_action_pressed("Join_kb_2"):
			new_player(keyboard_input_2)
	
func _duplicate_input(id:int,type:Input_Keys.device_type) -> Input_Keys:
	var new_keys=Input_Keys.new()
	for name in base_action_strings:
		var new_name=name+"_"+device_keys[type]+"_"+str(id)
		InputMap.add_action(new_name)
		var base_events = InputMap.action_get_events(name)
		for event in base_events:
			var new_event=event.duplicate()
			new_event.device=id
			InputMap.action_add_event(new_name,new_event)
	new_keys.device_id=id
	new_keys.device=type
	return new_keys


