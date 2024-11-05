extends SelectPanel
class_name CardSelectPanel

enum DeckType {ALL_SPELL,KNOWN_SPELL,ALL_SKIN,ALL_UNKNOWN_SPELL}
@export var title:String
@export var current_deck_type:DeckType
@export var cards:Deck
@export var left_card:Card
@export var center_card:Card
@export var right_card:Card
@export var center_display:CardDisplay
@export_category("Display Spawn Settings")
@export var spawn_display:bool = true
@export var handle_despawn_display:bool = true
@export var display_location:NodePath
@export var to_display:PackedScene
var displayed_card:CardDisplay
var can_select_left_right:bool = false
#@export var player_index:int
#enum display_mode {SELECTED,SELECTING,ZOOMED}
#var current_mode:display_mode
@export var context:Card.CardContext
@export var use_slot_index:bool = false
@export var slot_index:int

signal next_mode
signal back_mode
signal focus
signal selected

func _ready():
	#Get the default skins and display them
	reset()
	%Title.text = title
	#load_new_deck()

func change_title(new_title:String):
	title = new_title
	%Title.text = title

func new_player(new_player_index:int):
	player_index = new_player_index
	load_new_deck()
	reset()

func load_deck(new_deck:Deck):
	cards = new_deck
	
	
func load_new_deck():
	if current_deck_type==DeckType.ALL_SKIN:
		cards = GameManager.universal_skin_deck
	elif current_deck_type == DeckType.ALL_SPELL:
		cards=GameManager.universal_spell_deck.duplicate()
	elif current_deck_type==DeckType.KNOWN_SPELL:
		print(player_index)
		print(GameManager.players)
		#cards = GameManager.universal_spell_deck.subdeck(GameManager.players[player_index].get('known_spells'))
		cards = GameManager.players[player_index]['known_spells_deck']
	elif current_deck_type==DeckType.ALL_UNKNOWN_SPELL:
		print(player_index)
		print(GameManager.players)
		cards = GameManager.universal_spell_deck.subdeck(range(GameManager.universal_spell_deck.cards.size()),GameManager.players[player_index].get('known_spells'))

func reset():
	var to_display = cards.start_cards()
	new_cards(to_display)
	refresh()

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
		SoundFX.move()
		#%MenuMove.play()
@rpc("any_peer","call_local")
func right():
	if can_select_left_right:
		new_cards(cards.next_cards(right_card))
		SoundFX.move()
		#%MenuMove.play()
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
		SoundFX.select()
		#%SelectNoise.play()
	elif cards.select(center_card):
		next_mode.emit()
		SoundFX.select()
		#%SelectNoise.play()
@rpc("any_peer","call_local")
func back():
	if !first:
		back_mode.emit()
	SoundFX.back()

func display():
	if spawn_display:
		displayed_card = to_display.instantiate()
		get_node(display_location).add_child(displayed_card)
		displayed_card.set_new_card(center_card)
		displayed_card.set_display_style(CardDisplay.DisplayStyle.DISPLAYING)

func undisplay():
	
	if displayed_card !=null and handle_despawn_display:
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
		%CenterCard.set_mode(CardDisplay.Mode.UNSELECTABLE)
	else:
		pass
		%SelectButton.text="Select"
		%SelectButton.disabled=false
		%CenterCard.set_mode(CardDisplay.Mode.CLEAR)
	left_card=to_display[1]
	%LeftCard.set_new_card(left_card)
	center_card=to_display[2]
	%CenterCard.set_new_card(center_card)
	center_display=%CenterCard
	right_card=to_display[3]
	%RightCard.set_new_card(right_card)




func _on_left_button_button_down():
	if GameManager.players[player_index]['peer_id']==multiplayer.get_unique_id():
		left.rpc()


func _on_right_button_button_down():
	if GameManager.players[player_index]['peer_id']==multiplayer.get_unique_id():
		right.rpc()


func _on_select_button_button_down():
	if GameManager.players[player_index]['peer_id']==multiplayer.get_unique_id():
		select.rpc()


func _on_center_card_new_name(name):
	#if name == "":
		#%NameBox.visible = false
	#else:
		#%NameBox.visible = true
	%Name.text = name


func _on_zoomed_select():
	
	if use_slot_index:
		(center_card as SpellCard).select(player_index,context,slot_index)
	else:
		center_card.select(player_index,context)
	selected.emit()
	display()
	refresh()
	next.emit()
	#new_cards(cards.next_cards(center_card))


func _on_selected_unselect():
	#exit.emit()
	undisplay()
	print("unselect A")
	cards.unselect(center_card)
	center_card.unselect(player_index,context)
	refresh()
	#new_cards(cards.next_cards(center_card))
	#unselect()


func _on_focused_unfocus():
	refresh()
	exit.emit()
	

func focused():
	load_new_deck()
	refresh()
	focus.emit()
