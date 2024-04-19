extends Node

@export var player_scene:PackedScene
@export var registered_controller_ids:Array[int]=[]
@export var registered_keyboard_ids:Array[int]=[]
@export var base_action_strings:Array[String]=[]
enum device_type {keyboard,joystick}
var device_keys={device_type.keyboard:"kb",device_type.joystick:"joy"}
@export var keyboard_input_1:Input_Keys
@export var keyboard_input_2:Input_Keys
@export var spawn_vectors:Array[Vector2]=[Vector2(100,100),Vector2(400,100),Vector2(100,400),Vector2(400,400)]
var player_count:int =0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	var id = event.device
	var type=device_type.keyboard
	if event.is_action_pressed("Join_joy_1") and !registered_controller_ids.has(id):
		type=device_type.joystick
		registered_controller_ids.append(id)
		var new_player = player_scene.instantiate()
		get_parent().add_child(new_player)
		var new_keys=_duplicate_input(id,type)
		new_player.initialize(next_position(),new_keys)
		player_count+=1
	if event.is_action_pressed("Join_kb_1") and !registered_keyboard_ids.has(1):
		type=device_type.keyboard
		id=1
		registered_keyboard_ids.append(id)
		var new_player = player_scene.instantiate()
		get_parent().add_child(new_player)
		new_player.initialize(next_position(),keyboard_input_1)
		player_count+=1
	if event.is_action_pressed("Join_kb_2") and !registered_keyboard_ids.has(2):
		type=device_type.keyboard
		id=2
		registered_keyboard_ids.append(id)
		var new_player = player_scene.instantiate()
		get_parent().add_child(new_player)
		new_player.initialize(next_position(),keyboard_input_2)
		player_count+=1
	
func _duplicate_input(id:int,type:device_type) -> Input_Keys:
	InputMap.get_actions()
	var new_keys=Input_Keys.new()
	for name in base_action_strings:
		var new_name=name+"_"+device_keys[type]+"_"+str(id)
		InputMap.add_action(new_name)
		var base_events = InputMap.action_get_events(name)
		for event in base_events:
			var new_event=event.duplicate()
			new_event.device=id
			InputMap.action_add_event(new_name,new_event)
	return new_keys

func next_position() -> Vector2:
	return spawn_vectors[player_count]
	
