extends PanelContainer
class_name CardSelectPanel

@export var cards:Deck
@export var left_card:Card
@export var center_card:Card
@export var right_card:Card
@export var center_display:CardDisplay
@export var player_index:int
enum display_mode {SELECTED,SELECTING,ZOOMED}
var current_mode:display_mode



func _ready():
	#Get the default skins and display them
	var to_display = cards.start_cards()
	new_cards(to_display)
	refresh()
	
	

func refresh():
	new_cards(cards.next_cards(center_card))
	%LeftCard.reset_shader()
	%CenterCard.reset_shader()
	%RightCard.reset_shader()

signal exit()
signal next()

@rpc("any_peer","call_local")
func left():
	if current_mode != display_mode.ZOOMED:
		new_cards(cards.next_cards(left_card))
		%MenuMove.play()
@rpc("any_peer","call_local")
func right():
	if current_mode != display_mode.ZOOMED:
		new_cards(cards.next_cards(right_card))
		%MenuMove.play()
@rpc("any_peer","call_local")
func up():
	pass
@rpc("any_peer","call_local")
func down():
	pass
@rpc("any_peer","call_local")
func select():
	if center_card is RandomCard:
		new_cards(cards.next_cards(cards.random()))
		%SelectNoise.play()
	if current_mode == display_mode.ZOOMED and cards.select(center_card):
		center_card.select(player_index)
		new_cards(cards.next_cards(center_card))
		next.emit()
		%SelectNoise.play()
	if current_mode == display_mode.SELECTING:
		transition_display_mode(display_mode.ZOOMED)
		%SelectNoise.play()
	else:
		pass
@rpc("any_peer","call_local")
func back():
	if current_mode != display_mode.ZOOMED:
		exit.emit()
		%BackNoise.play()
	else:
		transition_display_mode(display_mode.SELECTING)
		%BackNoise.play()

@rpc("any_peer","call_local")
func unselect():
	cards.unselect(center_card)
	center_card.unselect(player_index)
	new_cards(cards.next_cards(center_card))
	
func new_cards(to_display:Array):
	if to_display[0]==false:
		pass
		%SelectButton.text="Selected"
		%SelectButton.disabled=true
	else:
		pass
		%SelectButton.text="Select"
		%SelectButton.disabled=false
	left_card=to_display[1]
	%LeftCard.set_new_card(left_card)
	center_card=to_display[2]
	%CenterCard.set_new_card(center_card)
	center_display=%CenterCard
	right_card=to_display[3]
	%RightCard.set_new_card(right_card)

func transition_display_mode(new_mode:display_mode):
	if new_mode==display_mode.SELECTED:
		visible=false
		%LeftButton.visible=false
		%LeftCard.visible=false
		%SelectButton.visible=false
		%RightButton.visible=false
		%RightCard.visible=false
		%CenterCard.set_display_style(CardDisplay.DisplayStyle.ICON)
		%LeftCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
		%RightCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
	if new_mode==display_mode.SELECTING:
		visible=true
		%LeftButton.visible=true
		%LeftCard.visible=true
		%SelectButton.visible=true
		%RightButton.visible=true
		%RightCard.visible=true
		%CenterCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
		%LeftCard.set_display_style(CardDisplay.DisplayStyle.TINY)
		%RightCard.set_display_style(CardDisplay.DisplayStyle.TINY)
	if new_mode==display_mode.ZOOMED:
		visible=true
		%LeftButton.visible=false
		%LeftCard.visible=false
		%SelectButton.visible=true
		%RightButton.visible=false
		%RightCard.visible=false
		%CenterCard.set_display_style(CardDisplay.DisplayStyle.ZOOMED)
		%LeftCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
		%RightCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
	current_mode=new_mode


func _on_left_button_button_down():
	if GameManager.players[player_index]['peer_id']==multiplayer.get_unique_id():
		left()


func _on_right_button_button_down():
	if GameManager.players[player_index]['peer_id']==multiplayer.get_unique_id():
		right()


func _on_select_button_button_down():
	if GameManager.players[player_index]['peer_id']==multiplayer.get_unique_id():
		select()


func _on_center_card_new_name(name):
	if name == "":
		%NameBox.visible = false
	else:
		%NameBox.visible = true
		%Name.text = name
