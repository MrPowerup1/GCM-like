extends SelectPanel
class_name MultiSpellSelect

@export var cards:Deck
@export var start_focus:PanelContainer
var focus:PanelContainer
var hovering:bool = true

signal to_hovering
signal to_selecting

func _ready() -> void:
	focus = start_focus

func hover_card(new_focus):
	if new_focus != null:
		assert(new_focus is PanelContainer,"Focusing on non Card Display object")
		new_focus.get_child(0).set_display_style(CardDisplay.DisplayStyle.HOVERING)
		focus.get_child(0).set_display_style(CardDisplay.DisplayStyle.STANDARD)
		focus = new_focus
		%CardSelect.display_location = %CardSelect.get_path_to(new_focus)
		SoundFX.move()
		%CardSelect.change_title(focus.name)
	else:
		SoundFX.back()

@rpc("any_peer","call_local")
func left():
	if hovering:
		var new_focus = focus.get_node(focus.focus_neighbor_left)
		hover_card(new_focus)
	else: 
		%CardSelect.left()

@rpc("any_peer","call_local")
func right():
	if hovering:
		var new_focus = focus.get_node(focus.focus_neighbor_right)
		hover_card(new_focus)
		
	else: 
		%CardSelect.right()

@rpc("any_peer","call_local")
func up():
	if hovering:
		var new_focus = focus.get_node(focus.focus_neighbor_top)
		hover_card(new_focus)
	else: 
		SoundFX.back()

@rpc("any_peer","call_local")
func down():
	if hovering:
		var new_focus = focus.get_node(focus.focus_neighbor_bottom)
		hover_card(new_focus)
	else: 
		to_hovering.emit()
		SoundFX.back()

@rpc("any_peer","call_local")
func select():
	if hovering:
		to_selecting.emit()
	else:
		%CardSelect.select()
		to_hovering.emit()
	SoundFX.select()
	
@rpc("any_peer","call_local")
func back():
	if hovering:
		pass
	else:
		%CardSelect.back()
		to_hovering.emit()
	SoundFX.back()


func _on_card_select_selected() -> void:
	focus.get_child(0).queue_free()
