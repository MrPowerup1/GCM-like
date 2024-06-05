extends PanelContainer
class_name PlayerPanel


enum style {AWAIT_PLAYER,SKIN_SELECT,SPELL_SELECT1,SPELL_SELECT2,PLAYER_READY}
var current_style:style = style.AWAIT_PLAYER
var current_player:PlayerUIInput
var current_player_index:int
var now_ready:bool = false
var active_panel:Control
var reading_inputs:bool = true
var cooldown_ready:bool = true
@export var card_scene:PackedScene

signal player_quit(player:Player)
signal player_ready()
signal player_unready()

func player_join(player:PlayerUIInput,player_index:int):
	print ('A player joined ',player)
	current_player=player
	current_player_index=player_index
	%SkinSelect.player_index=current_player_index
	%SpellSelect1.player_index=current_player_index
	%SpellSelect2.player_index=current_player_index
	
	#Timer to wait out the initial input to join
	%InputCooldown.start()
	cooldown_ready=false
	if current_player!=null:
		current_player.button_activate.connect(button_input)
		current_player.direction_pressed.connect(directional_input)
	
	%SkinSelect.cards=GameManager.universal_skin_deck
	var spell_deck = GameManager.universal_spell_deck.subdeck(GameManager.players[current_player_index].get('known_spells'))
	%SpellSelect1.cards=spell_deck
	%SpellSelect2.cards=spell_deck

func quit():
	if current_player!=null:
		player_quit.emit(current_player)
		current_player=null
		queue_free()

func reset():
	if current_player!=null:
		$StateManager/Ready.reset()


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





