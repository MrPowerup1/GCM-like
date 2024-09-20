extends PanelContainer
class_name PlayerPanel


#enum style {AWAIT_PLAYER,SKIN_SELECT,SPELL_SELECT1,SPELL_SELECT2,PLAYER_READY}
#var current_style:style = style.AWAIT_PLAYER
var attached_player:bool = false
var now_ready:bool = false
#var active_panel:Control
var reading_inputs:bool = true
var cooldown_ready:bool = true
var card_select_list:Array

@export var card_scene:PackedScene


signal player_quit(player:PlayerUIInput)
signal player_ready()
signal player_unready()
signal player_joined(index:int)


func directional_input(direction:Vector2):
	if cooldown_ready and reading_inputs:
		cooldown_ready=false
		%InputCooldown.start()
		if direction.x >0:
			%Displays.active_panel.right.rpc()
		if direction.x < 0:
			%Displays.active_panel.left.rpc()
		if direction.y < 0:
			%Displays.active_panel.up.rpc()
		if direction.y > 0:
			%Displays.active_panel.down.rpc()	

func button_input(button_index:int):
	if cooldown_ready and reading_inputs:
		cooldown_ready=false
		%InputCooldown.start()
		if button_index == 0:
			%Displays.active_panel.select.rpc()
		if button_index == 1:
			%Displays.active_panel.back.rpc()


func select(panel:CardSelectPanel):
	#panel.reparent(%Selected)
	var new_selection = card_scene.instantiate()
	if (new_selection is CardDisplay):
		%Selected.add_child(new_selection)
		(new_selection as CardDisplay).set_new_card(panel.center_card)
		(new_selection as CardDisplay).set_display_style(CardDisplay.DisplayStyle.ICON)
	else:
		pass
		
func unselect(panel:CardSelectPanel):
	#panel.reparent(%Unselected)
	%Selected.remove_child(%Selected.get_child(-1))
	panel.unselect()	


func _on_input_cooldown_timeout():
	cooldown_ready=true


@rpc("call_local","any_peer")
func add_player(index:int):#input:Input_Keys):
	#if the player has already been assigned, just function
	var remote_id = multiplayer.get_remote_sender_id()
	var local_id = multiplayer.get_unique_id()
	#TODO:what is this for?
	if remote_id ==local_id:
		if %PlayerUIInput.player_index==index:
			%PlayerUIInput.button_activate.connect(button_input)
			%PlayerUIInput.direction_pressed.connect(directional_input)
		elif GameManager.local_players.has(index):
			%PlayerUIInput.player_index = index
			#print(GameManager.local_players[index]['input_keys'])
			%PlayerUIInput.input_keys = Input_Keys.from_dict(GameManager.local_players[index]['input_keys'])
			%PlayerUIInput.button_activate.connect(button_input)
			%PlayerUIInput.direction_pressed.connect(directional_input)
		else:
			printerr("No known player of index ",index)
			return
	%PlayerUIInput.player_index = index
	attached_player=true
	player_joined.emit(%PlayerUIInput.player_index)
	#%Displays.player_joined(%PlayerUIInput.player_index)


func delete_player():
	print ("System ", multiplayer.get_unique_id()," Trying to remove player")
	#var to_del_input = player.input_keys
	if GameManager.remove_player(%PlayerUIInput.player_index):
		print("Sucessfully removed player at index ",%PlayerUIInput.player_index)
	else:
		print ("Couldn't find player at index ",%PlayerUIInput.player_index)
	player_quit.emit()
	attached_player=false
	queue_free()

func _on_await_player_player_joined(index:int):
	add_player.rpc(index)


func _on_await_player_player_quit():
	delete_player()


func _on_player_ready_player_ready():
	now_ready=true
	player_ready.emit()


func _on_player_ready_player_unready():
	now_ready=false
	player_unready.emit()
