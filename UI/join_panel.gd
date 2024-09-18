extends SelectPanel

var animator:AnimationPlayer
@export var base_action_strings:Array[String]=[]
var device_keys={Input_Keys.device_type.KEYBOARD:"kb",Input_Keys.device_type.JOYSTICK:"joy"}
@export var keyboard_input_1:Input_Keys
@export var keyboard_input_2:Input_Keys
var null_input:Input_Keys = load("res://Inputs/Null Input.tres")
@export var display_location:Control
@export var to_display:PackedScene
var displayed_info:Control
@export var player:PlayerUIInput


var accepting_input:bool =true

signal player_joined(index:int)
signal player_quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	%AnimationPlayer.play("Animate Join Sprite")

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
	accepting_input=false
	visible=false
@rpc("any_peer","call_local")
func back():
	pass

func display():
	displayed_info=to_display.instantiate()
	displayed_info.player_index = player_index
	displayed_info.device = player.input_keys.device
	display_location.add_child(displayed_info)

func undisplay():
	if displayed_info !=null:
		displayed_info.queue_free()
	

func new_player_keys(input:Input_Keys):
	player.input_keys = input
	add_player.rpc()
	select.rpc()
	display()
	#await get_tree().create_timer(0.1)
	player_joined.emit(player_index)

@rpc("call_local","any_peer")	
func add_player():
	var remote_id = multiplayer.get_remote_sender_id()
	var local_id = multiplayer.get_unique_id()
	if remote_id ==local_id:	
		player_index = GameManager.add_player(local_id,player.input_keys)
	else:
		player_index =GameManager.add_player(remote_id,null_input)
	player.player_index=player_index


func _unhandled_input(event):
	if accepting_input:
		var id = event.device
		var type=Input_Keys.device_type.JOYSTICK
		if event.is_action_pressed("Join_joy_1"):
			var new_keys=_duplicate_input(id,type)
			new_player_keys(new_keys)
		type=Input_Keys.device_type.KEYBOARD
		if event.is_action_pressed("Join_kb_1"):
			new_player_keys(keyboard_input_1)
		if event.is_action_pressed("Join_kb_2"):
			new_player_keys(keyboard_input_2)
	
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

func focused():
	player_quit.emit()
