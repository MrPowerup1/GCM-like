extends PanelContainer
class_name PlayerPanel


enum style {AWAIT_PLAYER,SKIN_SELECT,SPELL_SELECT,PLAYER_READY}
var current_style:style = style.AWAIT_PLAYER
var current_player:PlayerManager
var now_ready:bool = true
var active_panel:Control
var reading_inputs:bool = true

signal player_quit(player:PlayerManager)
signal player_ready()
signal player_unready()

func player_join(player:PlayerManager):
	current_player=player
	transition_style(style.SKIN_SELECT)
	await get_tree().create_timer(0.25).timeout
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
		%"Join Panel".visible=false
		%"Skin Select Panel".visible=true
		%"PlayerReady".visible=false
		now_ready=false
		current_style=new_style
		active_panel=%"Skin Select Panel"
		
	if (new_style==style.PLAYER_READY):
		%PlayerReady.visible=true
		now_ready=true
		player_ready.emit()
		current_style=new_style
		active_panel=%PlayerReady

func directional_input(direction:Vector2):
	if reading_inputs and active_panel != null:
		if direction.x >0:
			active_panel.right()
		if direction.x < 0:
			active_panel.left()
		if direction.y < 0:
			active_panel.up()
		if direction.y > 0:
			active_panel.down()	

func button_input(button_index:int):
	if reading_inputs and active_panel != null:
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
	transition_style(style.PLAYER_READY)

func _on_player_ready_exit():
	transition_style(style.SKIN_SELECT)
	player_unready.emit()
	print ("player unready here")
