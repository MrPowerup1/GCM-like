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
	#Timer to wait out the initial input to join
	%InputCooldown.start()
	cooldown_ready=false
	current_player.player_character.my_input.button_activate.connect(button_input)
	current_player.player_character.my_input.direction_pressed.connect(directional_input)
	current_player.player_character.my_input.input_mode_changed.connect(change_input_mode)
	
	
	

func quit():
	player_quit.emit(current_player)
	current_player=null
	print ("I quit")
	queue_free()
	
func transition_style(new_style:style):
	if (new_style==style.SKIN_SELECT):
		%"AwaitPlayer".visible=false
		%"SkinSelect".visible=true
		%SpellSelect.visible=false
		%SkinSelect.transition_display_mode(SkinSelectPanel.display_mode.SELECTING)
		active_panel=%"SkinSelect"
		
	if (new_style==style.SPELL_SELECT1):
		active_panel=%SpellSelect
		%SpellSelect.visible=true
		%SpellSelect2.visible=false
		%SkinSelect.transition_display_mode(SkinSelectPanel.display_mode.SELECTED)
		%SpellSelect.transition_display_mode(SpellSelectPanel.display_mode.SELECTING)
		now_ready=false
		
	if (new_style==style.SPELL_SELECT2):
		active_panel=%SpellSelect2
		%SpellSelect2.visible=true
		%PlayerReady.visible=false
		%SpellSelect.transition_display_mode(SpellSelectPanel.display_mode.SELECTED)
		%SpellSelect2.transition_display_mode(SpellSelectPanel.display_mode.SELECTING)
		now_ready=false
		
	if (new_style==style.PLAYER_READY):
		%SpellSelect2.transition_display_mode(SpellSelectPanel.display_mode.SELECTED)
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
			active_panel.right()
		if direction.x < 0:
			active_panel.left()
		if direction.y < 0:
			active_panel.up()
		if direction.y > 0:
			active_panel.down()	

func button_input(button_index:int):
	if cooldown_ready and reading_inputs and active_panel != null:
		cooldown_ready=false
		%InputCooldown.start()
		if button_index == 0:
			active_panel.select()
		if button_index == 1:
			active_panel.back()

func change_input_mode(new_style:PlayerCharacterInput.input_mode):
	if new_style == PlayerCharacterInput.input_mode.GAMEPLAY:
		reading_inputs=false
	elif new_style == PlayerCharacterInput.input_mode.UI:
		reading_inputs=true

func _on_skin_select_panel_exit():
	transition_style(style.AWAIT_PLAYER)
	quit()

func _on_skin_select_panel_next():
	transition_style(style.SPELL_SELECT1)
	current_player.set_skin(%SkinSelect.center_skin)

func _on_player_ready_exit():
	transition_style(style.SPELL_SELECT2)
	player_unready.emit()
	print ("player unready here")
	%SpellSelect2.unselect_spell()


func _on_join_panel_next():
	pass # Replace with function body.

func _on_input_cooldown_timeout():
	cooldown_ready=true


func _on_spell_select_exit():
	transition_style(style.SKIN_SELECT)
	%SkinSelect.unselect_skin()


func _on_spell_select_next():
	transition_style(style.SPELL_SELECT2)
	current_player.set_spell(0,%SpellSelect.center_spell)
	


func _on_spell_select_2_exit():
	transition_style(style.SPELL_SELECT1)
	%SpellSelect.unselect_spell()


func _on_spell_select_2_next():
	transition_style(style.PLAYER_READY)
	current_player.set_spell(1,%SpellSelect2.center_spell)
