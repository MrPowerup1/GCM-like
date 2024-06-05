extends State
class_name Ready



func enter():
	$"../..".active_panel=%PlayerReady
	%PlayerReady.visible=true
	$"../..".now_ready=true
	$"../..".player_ready.emit()

func exit():
	%PlayerReady.visible=false
	$"../..".now_ready=false
	
func _on_player_ready_exit():
	Transition.emit(self,"SelectSpell2")
	$"../..".player_unready.emit()
	$"../..".unselect(%SpellSelect2)

func reset():
	$"../..".player_unready.emit()
	$"../..".unselect(%SpellSelect2)
	$"../..".unselect(%SpellSelect1)
	$"../..".unselect(%SkinSelect)
	Transition.emit(self,"SelectSkin")
	#TODO: Fix this to work for new UI players
	if $"../..".current_player !=null:
		$"../..".current_player.stop_round()
