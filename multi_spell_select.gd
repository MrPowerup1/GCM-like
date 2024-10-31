extends SelectPanel
class_name MultiSpellSelect

enum DeckType {ALL_SPELL,KNOWN_SPELL,ALL_SKIN,ALL_UNKNOWN_SPELL}
@export var current_deck_type:DeckType
@export var cards:Deck
@export var start_focus:PanelContainer
var focus:PanelContainer
var hovering:bool = true

signal to_hovering
signal to_selecting


func new_player(new_player_index:int):
	player_index = new_player_index
	%"Top Spell".player_index = player_index
	%"Left Spell".player_index = player_index
	%"Right Spell".player_index = player_index
	%"Bottom Spell".player_index = player_index
	%CardSelect.player_index = player_index
	load_new_deck()

func load_deck(new_deck:Deck):
	cards = new_deck
	%"Top Spell".load_deck(cards)
	%"Left Spell".load_deck(cards)
	%"Right Spell".load_deck(cards)
	%"Bottom Spell".load_deck(cards)

func load_new_deck():
	if current_deck_type==DeckType.ALL_SKIN:
		cards = GameManager.universal_skin_deck
	elif current_deck_type == DeckType.ALL_SPELL:
		cards=GameManager.universal_spell_deck.duplicate()
	elif current_deck_type==DeckType.KNOWN_SPELL:
		print(player_index)
		print("THIS HERE IS MY FRICKIN PLAYER INDEX")
		#cards = GameManager.universal_spell_deck.subdeck(GameManager.players[player_index].get('known_spells'))
		cards = GameManager.players[player_index]['known_spells_deck']
	elif current_deck_type==DeckType.ALL_UNKNOWN_SPELL:
		print(player_index)
		print(GameManager.players)
		cards = GameManager.universal_spell_deck.subdeck(range(GameManager.universal_spell_deck.cards.size()),GameManager.players[player_index].get('known_spells'))
	load_deck(cards)



func _ready() -> void:
	focus = start_focus

func hover_card(new_focus):
	if new_focus != null:
		assert(new_focus is PanelContainer,"Focusing on non Card Display object")
		new_focus.get_child(0).set_display_style(CardDisplay.DisplayStyle.HOVERING)
		focus.get_child(0).set_display_style(CardDisplay.DisplayStyle.DISPLAYING)
		focus = new_focus
		%CardSelect.display_location = %CardSelect.get_path_to(new_focus)
		%CardSelect.load_deck(cards)
		SoundFX.move()
		%CardSelect.change_title(focus.name)
		%CardSelect.center_card = focus.get_child(0).card
		%CardSelect.slot_index = focus.spell_slot_index
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
		print("Player ",player_index," Is selecting")
		cards.unselect(focus.get_child(0).card)
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
