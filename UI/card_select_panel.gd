extends SelectPanel
class_name CardSelectPanel

enum DeckType {ALL_SPELL,KNOWN_SPELL,ALL_SKIN}
@export var current_deck_type:DeckType
@export var cards:Deck
@export var left_card:Card
@export var center_card:Card
@export var right_card:Card
@export var center_display:CardDisplay
@export var display_location:Control
@export var to_display:PackedScene
var displayed_card:CardDisplay
var can_select_left_right:bool = false
#@export var player_index:int
#enum display_mode {SELECTED,SELECTING,ZOOMED}
#var current_mode:display_mode

signal next_mode
signal back_mode
signal focus

func _ready():
	#Get the default skins and display them
	var to_display = cards.start_cards()
	new_cards(to_display)
	refresh()
	#load_new_deck()

func new_player(new_player_index:int):
	player_index = new_player_index
	load_new_deck()

func load_new_deck():
	if current_deck_type==DeckType.ALL_SKIN:
		cards = GameManager.universal_skin_deck
	elif current_deck_type == DeckType.ALL_SPELL:
		cards=GameManager.universal_spell_deck.duplicate()
	elif current_deck_type==DeckType.KNOWN_SPELL:
		cards = GameManager.universal_spell_deck.subdeck(GameManager.players[player_index].get('known_spells'))

func refresh():
	new_cards(cards.next_cards(center_card))
	%LeftCard.reset_shader()
	%CenterCard.reset_shader()
	%RightCard.reset_shader()

#signal exit()
#signal next()

@rpc("any_peer","call_local")
func left():
	if can_select_left_right:
		new_cards(cards.next_cards(left_card))
		%MenuMove.play()
@rpc("any_peer","call_local")
func right():
	if can_select_left_right:
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
	elif cards.select(center_card):
		next_mode.emit()
		%SelectNoise.play()
@rpc("any_peer","call_local")
func back():
	back_mode.emit()
	%BackNoise.play()

func display():
	displayed_card = to_display.instantiate()
	display_location.add_child(displayed_card)
	displayed_card.set_new_card(center_card)
	displayed_card.set_display_style(CardDisplay.DisplayStyle.DISPLAYING)

func undisplay():
	if displayed_card !=null:
		displayed_card.queue_free()
	#to_display.current_style = CardDisplay.DisplayStyle.INVISIBLE


#@rpc("any_peer","call_local")
#func unselect():
	#cards.unselect(center_card)
	#center_card.unselect(player_index)
	#new_cards(cards.next_cards(center_card))
	
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

#func transition_display_mode(new_mode:display_mode):
	#if new_mode==display_mode.SELECTED:
		#visible=false
		#%LeftButton.visible=false
		#%LeftCard.visible=false
		#%SelectButton.visible=false
		#%RightButton.visible=false
		#%RightCard.visible=false
		#%CenterCard.set_display_style(CardDisplay.DisplayStyle.ICON)
		#%LeftCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
		#%RightCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
	#if new_mode==display_mode.SELECTING:
		#visible=true
		#%LeftButton.visible=true
		#%LeftCard.visible=true
		#%SelectButton.visible=true
		#%RightButton.visible=true
		#%RightCard.visible=true
		#%CenterCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
		#%LeftCard.set_display_style(CardDisplay.DisplayStyle.TINY)
		#%RightCard.set_display_style(CardDisplay.DisplayStyle.TINY)
	#if new_mode==display_mode.ZOOMED:
		#visible=true
		#%LeftButton.visible=false
		#%LeftCard.visible=false
		#%SelectButton.visible=true
		#%RightButton.visible=false
		#%RightCard.visible=false
		#%CenterCard.set_display_style(CardDisplay.DisplayStyle.ZOOMED)
		#%LeftCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
		#%RightCard.set_display_style(CardDisplay.DisplayStyle.STANDARD)
	#current_mode=new_mode


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
	#if name == "":
		#%NameBox.visible = false
	#else:
		#%NameBox.visible = true
	%Name.text = name


func _on_zoomed_select():
	next.emit()
	display()
	center_card.select(player_index)
	refresh()
	#new_cards(cards.next_cards(center_card))


func _on_selected_unselect():
	#exit.emit()
	undisplay()
	cards.unselect(center_card)
	center_card.unselect(player_index)
	refresh()
	#new_cards(cards.next_cards(center_card))
	#unselect()


func _on_focused_unfocus():
	exit.emit()
	refresh()

func focused():
	focus.emit()
