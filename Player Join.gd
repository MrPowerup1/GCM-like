extends Node
class_name PlayerJoin

@export var player_ui_scene:PackedScene
var registered_ids = {}
@export var base_action_strings:Array[String]=[]
var device_keys={Input_Keys.device_type.KEYBOARD:"kb",Input_Keys.device_type.JOYSTICK:"joy"}
@export var null_input:Input_Keys
@export var keyboard_input_1:Input_Keys
@export var keyboard_input_2:Input_Keys
@export var spawn_vectors:Array[Vector2]=[Vector2(100,100),Vector2(200,100),Vector2(100,200),Vector2(200,200)]
var player_count:int =0

var searching:bool=false

signal player_joined(new_player:PlayerUIInput,index:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if searching:
		var id = event.device
		var type=Input_Keys.device_type.JOYSTICK
		if event.is_action_pressed("Join_joy_1") and (!registered_ids.has(id) or registered_ids[id]!=type):
			registered_ids [id]=type
			var new_keys=_duplicate_input(id,type)
			add_player(id,new_keys)
			add_remote_player.rpc(id)
		type=Input_Keys.device_type.KEYBOARD
		if event.is_action_pressed("Join_kb_1") and (!registered_ids.has(-1) or registered_ids[-1]!=type):
			id=-1
			registered_ids [id]=type
			add_player(id,keyboard_input_1)
			add_remote_player.rpc(id)
		if event.is_action_pressed("Join_kb_2") and (!registered_ids.has(-2) or registered_ids[-2]!=type):
			id=-2
			registered_ids [id]=type
			add_player(id,keyboard_input_2)
			add_remote_player.rpc(id)
	
func _duplicate_input(id:int,type:Input_Keys.device_type) -> Input_Keys:
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
	new_keys.device_id=id
	new_keys.device=type
	return new_keys

#TODO MAKE THIS REAl
func next_position() -> Vector2:
	return spawn_vectors[player_count%spawn_vectors.size()]

func add_player(local_id:int, input:Input_Keys):
	var player_index = GameManager.add_player(multiplayer.get_unique_id(),input)
	var new_player = player_ui_scene.instantiate()
	add_child(new_player)
	new_player.input_keys = input
	player_joined.emit(new_player,player_index)
	player_count+=1

@rpc("call_remote","any_peer")
func add_remote_player(local_id:int):
	var player_index = GameManager.add_player(multiplayer.get_remote_sender_id(),null_input)
	var new_player = player_ui_scene.instantiate()
	add_child(new_player)
	new_player.input_keys = null_input
	player_joined.emit(new_player,player_index)
	player_count+=1
	
func delete_player(player:Player):
	print ("Deleted player here yaya")
	if player.player_character.my_input!=null:
		var to_del_input = player.player_character.my_input.input_keys
		if registered_ids.has(to_del_input.device_id) and registered_ids[to_del_input.device_id]==to_del_input.device:
			registered_ids.erase(to_del_input.device_id)
			if GameManager.players.has(player.player_index):
				GameManager.players.erase(player.player_index)
			print("Deleted id")
	player.queue_free()
