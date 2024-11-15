extends SelectPanel
class_name MultiSpellSelect

enum DeckType {ALL_SPELL,KNOWN_SPELL,ALL_SKIN,ALL_UNKNOWN_SPELL}
@export var current_deck_type:DeckType
@export var cards:Deck
@export var start_focus:PanelContainer
@export var spell_axis:SpellAxis
var focus:PanelContainer
var hovering:bool = true

signal to_hovering
signal to_selecting
signal to_finished
signal to_unfocused


func new_player(new_player_index:int):
	player_index = new_player_index
	spell_axis.set_player_index(new_player_index)
	#%"Learn Spell".player_index = player_index
	%CardSelect.player_index = player_index
	load_new_deck()
	print("new player loaded")
	if GameManager.players[new_player_index].has('selected_spells'):
		print("Loading existing spells")
		spell_axis.load_spells(GameManager.players[new_player_index]['selected_spells'])

func load_deck(new_deck:Deck):
	print("TOPIC unselect: deck loaded")
	cards = new_deck
	spell_axis.set_deck(new_deck)
	%"Spell Axis".set_display_style(CardDisplay.DisplayStyle.TINY)
	
	#%"Learn Spell".load_deck(GameManager.universal_spell_deck.subdeck(range(GameManager.universal_spell_deck.cards.size()),GameManager.players[player_index].get('known_spells')))

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
		new_focus.get_child(0).set_display_style(CardDisplay.DisplayStyle.HOVERING)
		%CardSelect.display_location = %CardSelect.get_path_to(new_focus)
		%CardSelect.load_deck(new_focus.filtered_cards)
		SoundFX.move()
		%CardSelect.change_title(new_focus.name)
		var new_card = new_focus.get_child(0).card
		if new_focus.filtered_cards.has_card(new_card):
			%CardSelect.center_card = new_focus.get_child(0).card
		%CardSelect.slot_index = new_focus.spell_slot_index
	else:
		SoundFX.back()

func unhover_card(old_focus):
	old_focus.get_child(0).set_display_style(CardDisplay.DisplayStyle.DISPLAYING)

func hover(new_focus):
	if new_focus !=null:
		assert(new_focus is PanelContainer,"Focusing on non PanelContainer object")
		new_focus.highlight(true)
		focus.highlight(false)
		if new_focus is CardDisplayContainer:
			hover_card(new_focus)
		if focus is CardDisplayContainer:
			unhover_card(focus)
		focus = new_focus
	else:
		SoundFX.back()

@rpc("any_peer","call_local")
func left():
	if hovering:
		var new_focus = focus.get_node(focus.focus_neighbor_left)
		hover(new_focus)
	else: 
		%CardSelect.left()

@rpc("any_peer","call_local")
func right():
	if hovering:
		var new_focus = focus.get_node(focus.focus_neighbor_right)
		hover(new_focus)
		
	else: 
		%CardSelect.right()

@rpc("any_peer","call_local")
func up():
	if hovering:
		var new_focus = focus.get_node(focus.focus_neighbor_top)
		hover(new_focus)
	else: 
		SoundFX.back()

@rpc("any_peer","call_local")
func down():
	if hovering:
		var new_focus = focus.get_node(focus.focus_neighbor_bottom)
		hover(new_focus)
	else: 
		to_hovering.emit()
		SoundFX.back()

@rpc("any_peer","call_local")
func select():
	if hovering:
		if focus is CardDisplayContainer:
			print("unselect B1")
			cards.unselect(focus.get_child(0).card)
			focus.reload_deck()
			%CardSelect.load_deck(focus.filtered_cards)
			focus.get_child(0).card.unselect(player_index,focus.context)
			to_selecting.emit()
			print("Player ",player_index," Is selecting")
		else:
			finished_selecting()
	else:
		%CardSelect.select()
		cards.select(%CardSelect.center_card)
		to_hovering.emit()
	SoundFX.select()
	
@rpc("any_peer","call_local")
func back():
	if hovering:
		exit.emit()
		to_unfocused.emit()
		#spell_axis.unlearn(%CardSelect.center_card)
		#to_selecting.emit()
		#print("Player ",player_index," Is selecting")
		#print("unselect B2")
		#cards.unselect(focus.get_child(0).card)
		#focus.get_child(0).card.unselect(player_index,focus.context)
	else:
		%CardSelect.back()
		to_hovering.emit()
	SoundFX.back()


func _on_card_select_selected() -> void:
	if focus.get_child_count() >0:
		focus.get_child(0).queue_free()


func _on_new_spell_selected() -> void:
	load_new_deck()

func finished_selecting():
	next.emit()
	to_finished.emit()
	
func entered_selecting():
	pass

func _on_button_button_down() -> void:
	finished_selecting()
	
func focused():
	load_new_deck()
	to_hovering.emit()

func unlearn(check_card:Card):
	spell_axis.unlearn(check_card)
