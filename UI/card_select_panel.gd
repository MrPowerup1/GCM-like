extends PanelContainer
class_name CardSelectPanel

@export var cards:Deck
@export var left_card:Card
@export var center_card:Card
@export var right_card:Card
@export var center_display:CardDisplay
@export var player_index:int
enum display_mode {SELECTED,SELECTING}
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
	new_cards(cards.next_cards(left_card))
@rpc("any_peer","call_local")
func right():
	new_cards(cards.next_cards(right_card))
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
	if cards.select(center_card):
		center_card.select(player_index)
		new_cards(cards.next_cards(center_card))
		next.emit()
	else:
		pass
@rpc("any_peer","call_local")
func back():
	exit.emit()

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
		%CenterCard.set_display_style(CardDisplay.DisplayStyle.ZOOMED)
		%LeftCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
		%RightCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
	current_mode=new_mode


func _on_left_button_button_down():
	if GameManager.players[player_index].get("local",false):
		left()


func _on_right_button_button_down():
	if GameManager.players[player_index].get("local",false):
		right()


func _on_select_button_button_down():
	if GameManager.players[player_index].get("local",false):
		select()
