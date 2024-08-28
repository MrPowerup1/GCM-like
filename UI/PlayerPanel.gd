extends PanelContainer
class_name PlayerPanel


enum style {AWAIT_PLAYER,SKIN_SELECT,SPELL_SELECT1,SPELL_SELECT2,PLAYER_READY}
var current_style:style = style.AWAIT_PLAYER
var attached_player:bool = false
var now_ready:bool = false
var active_panel:Control
var reading_inputs:bool = true
var cooldown_ready:bool = true
var card_select_list:Array
var null_input:Input_Keys = load("res://Inputs/Null Input.tres")
@export var card_scene:PackedScene
@export var keyboard:Texture2D
@export var joystick:Texture2D
@export var remote:Texture2D

signal player_quit(player:PlayerUIInput)
signal player_ready()
signal player_unready()
signal player_joined()

#func player_join(player:PlayerUIInput,player_index:int):
	#current_player=player
	#current_player_index=player_index
	#%Label.text=str(player_index)
	#%SkinSelect.player_index=current_player_index
	#%SpellSelect1.player_index=current_player_index
	#%SpellSelect2.player_index=current_player_index
	#
	##Timer to wait out the initial input to join
	#%InputCooldown.start()
	#cooldown_ready=false
	#if current_player!=null:
		#current_player.button_activate.connect(button_input)
		#current_player.direction_pressed.connect(directional_input)
	#
	#%SkinSelect.cards=GameManager.universal_skin_deck
	#var spell_deck = GameManager.universal_spell_deck.subdeck(GameManager.players[current_player_index].get('known_spells'))
	#%SpellSelect1.cards=spell_deck
	#%SpellSelect2.cards=spell_deck
	#player_joined.emit()
	
#func quit():
	#if current_player!=null:
		#player_quit.emit(current_player)
		#current_player.queue_free()
		#current_player=null
		#queue_free()

#func reset():
	#if current_player!=null:
		#$StateManager/Ready.reset()


func directional_input(direction:Vector2):
	if cooldown_ready and reading_inputs and active_panel != null:
		cooldown_ready=false
		%InputCooldown.start()
		if direction.x >0:
			active_panel.right.rpc()
		if direction.x < 0:
			active_panel.left.rpc()
		if direction.y < 0:
			active_panel.up.rpc()
		if direction.y > 0:
			active_panel.down.rpc()	

func button_input(button_index:int):
	if cooldown_ready and reading_inputs and active_panel != null:
		cooldown_ready=false
		%InputCooldown.start()
		if button_index == 0:
			active_panel.select.rpc()
		if button_index == 1:
			active_panel.back.rpc()


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



func add_player(input:Input_Keys):
	attached_player=true
	var player_index = GameManager.add_player(multiplayer.get_unique_id(),input)
	%PlayerUIInput.input_keys = input
	%PlayerUIInput.player_index = player_index
	%PlayerUIInput.button_activate.connect(button_input)
	%PlayerUIInput.direction_pressed.connect(directional_input)
	player_joined.emit()
	if input.device==Input_Keys.device_type.KEYBOARD:
		%ControlType.texture=keyboard
	if input.device==Input_Keys.device_type.JOYSTICK:
		%ControlType.texture=joystick
	%ControlType.visible=true
	%Label.text=str(player_index)
	%SkinSelect.player_index=player_index
	%SpellSelect1.player_index=player_index
	%SpellSelect2.player_index=player_index
	%SkinSelect.cards=GameManager.universal_skin_deck
	var spell_deck = GameManager.universal_spell_deck.subdeck(GameManager.players[player_index].get('known_spells'))
	%SpellSelect1.cards=spell_deck
	%SpellSelect2.cards=spell_deck

@rpc("call_remote","any_peer")
func add_remote_player():
	attached_player=true
	var player_index = GameManager.add_player(multiplayer.get_remote_sender_id(),null_input)
	%PlayerUIInput.input_keys = null_input
	%PlayerUIInput.player_index = player_index
	player_joined.emit()
	%ControlType.texture=remote
	%ControlType.visible=true
	%Label.text=str(player_index)
	%SkinSelect.player_index=player_index
	%SpellSelect1.player_index=player_index
	%SpellSelect2.player_index=player_index
	%SkinSelect.cards=GameManager.universal_skin_deck
	var spell_deck = GameManager.universal_spell_deck.subdeck(GameManager.players[player_index].get('known_spells'))
	%SpellSelect1.cards=spell_deck
	%SpellSelect2.cards=spell_deck
	
func delete_player():
	print ("System ", multiplayer.get_unique_id()," Trying to remove player")
	#var to_del_input = player.input_keys
	if GameManager.remove_player(%PlayerUIInput.player_index):
		print("Sucessfully removed player at index ",%PlayerUIInput.player_index)
	else:
		print ("Couldn't find player at index ",%PlayerUIInput.player_index)
	player_quit.emit()
	queue_free()

func _on_await_player_player_joined(input:Input_Keys):
	add_player(input)
	add_remote_player.rpc()
