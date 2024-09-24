extends VBoxContainer

var focus_index:int = 0
var active_panel:SelectPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	#active_panel = get_child(0)
	new_panel()
	for child in get_children():
		if child is SelectPanel:
			(child as SelectPanel).next.connect(next_display)
			(child as SelectPanel).exit.connect(back_display)

func next_display():
	focus_index+=1
	if get_child(focus_index) is SelectPanel:
		new_panel()
	else:
		next_display()
	

func back_display():
	focus_index-=1
	if get_child(focus_index) is SelectPanel:
		new_panel()
	else:
		back_display()

func player_joined(player_index:int):
	for child in get_children():
		if child is SelectPanel:
			(child as SelectPanel).new_player(player_index)

func new_panel():
	active_panel = get_child(focus_index)
	active_panel.focused()


func _on_player_panel_player_joined(index: int) -> void:
	player_joined(index)
