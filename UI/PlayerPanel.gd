extends PanelContainer
class_name PlayerPanel


enum style {AWAIT_PLAYER,SKIN_SELECT,SPELL_SELECT1,SPELL_SELECT2,PLAYER_READY}
var current_style:style = style.AWAIT_PLAYER
var current_player:PlayerManager
var now_ready:bool = true
var active_panel:Control
var reading_inputs:bool = true
var cooldown_ready:bool = true

signal player_quit(player:PlayerManager)
signal player_ready()
signal player_unready()

func player_join(player:PlayerManager):
	current_player=player
	transition_style(style.SKIN_SELECT)
	%SkinSelect.player=current_player
	%SpellSelect1.player=current_player
	%SpellSelect2.player=current_player
	#Timer to wait out the initial input to join
	%InputCooldown.start()
	cooldown_ready=false
	if current_player.player_character.my_input!=null:
		current_player.player_character.my_input.button_activate.connect(button_input)
		current_player.player_character.my_input.direction_pressed.connect(directional_input)
		current_player.player_character.my_input.input_mode_changed.connect(change_input_mode)
	

func quit():
	player_quit.emit(current_player)
	current_player=null
	queue_free()
	
func transition_style(new_style:style):
	if (new_style==style.SKIN_SELECT):
		%"AwaitPlayer".visible=false
		%"SkinSelect".visible=true
		%SpellSelect1.visible=false
		%SkinSelect.transition_display_mode(CardSelectPanel.display_mode.SELECTING)
		active_panel=%"SkinSelect"
		
	if (new_style==style.SPELL_SELECT1):
		active_panel=%SpellSelect1
		%SpellSelect1.visible=true
		%SpellSelect2.visible=false
		%SkinSelect.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
		%SpellSelect1.transition_display_mode(CardSelectPanel.display_mode.SELECTING)
		now_ready=false
		
	if (new_style==style.SPELL_SELECT2):
		active_panel=%SpellSelect2
		%SpellSelect2.visible=true
		%PlayerReady.visible=false
		%SpellSelect1.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
		%SpellSelect2.transition_display_mode(CardSelectPanel.display_mode.SELECTING)
		now_ready=false
		
	if (new_style==style.PLAYER_READY):
		%SpellSelect2.transition_display_mode(CardSelectPanel.display_mode.SELECTED)
		%PlayerReady.visible=true
		now_ready=true
		player_ready.emit()
		active_panel=%PlayerReady
		
	current_style=new_style
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

func change_input_mode(new_style:PlayerCharacterInput.input_mode):
	if new_style == PlayerCharacterInput.input_mode.GAMEPLAY:
		reading_inputs=false
	elif new_style == PlayerCharacterInput.input_mode.UI:
		reading_inputs=true

func select(panel:Control):
	#panel.reparent(%Selected)	
	%Selected.add_child(panel)

func unselect(panel:Control):
	#panel.reparent(%Unselected)
	%Selected.remove_child(panel)	

func _on_player_ready_exit():
	transition_style(style.SPELL_SELECT2)
	player_unready.emit()
	%SpellSelect2.unselect()


func _on_join_panel_next():
	pass # Replace with function body.

func _on_input_cooldown_timeout():
	cooldown_ready=true



func _on_spell_select_2_exit():
	transition_style(style.SPELL_SELECT1)
	%SpellSelect1.unselect()
	#unselect(%SpellSelect1)
	#unselect(%SpellSelect1.center_display)

func _on_spell_select_2_next():
	transition_style(style.PLAYER_READY)
	#select(%SpellSelect2.center_display)


func _on_skin_select_exit():
	transition_style(style.AWAIT_PLAYER)
	#%Unselected.add_child(%SkinSelect.center_display)
	quit()

func _on_skin_select_next():
	transition_style(style.SPELL_SELECT1)
	#select(%SkinSelect.center_display)


func _on_spell_select_1_exit():
	transition_style(style.SKIN_SELECT)
	#unselect(%SkinSelect.center_display)


func _on_spell_select_1_next():
	transition_style(style.SPELL_SELECT2)
	#select(%SpellSelect1.center_display)
