extends PanelContainer
class_name CardDisplayContainer

@export var do_filter:bool
enum Filter_Types {EXCLUDE,INCLUDE}
@export var filter_type:Filter_Types
@export var filter_strings:Array[String]
var unfiltered_cards:Deck
var filtered_cards:Deck
@export var to_display:PackedScene = load("res://UI/CardDisplay.tscn")
@export var blank_card:Card = load("res://Blank Card.tres")
@export var context:Card.CardContext
@export var spell_slot_index:int
var player_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reload_deck():
	if do_filter:
		apply_filter()
	else:
		filtered_cards = unfiltered_cards

func load_deck(new_deck:Deck):
	unfiltered_cards = new_deck
	if do_filter:
		apply_filter()
	else:
		filtered_cards = unfiltered_cards
	if get_child_count() > 0:
		pass
	elif GameManager.players[player_index]['selected_spells'][spell_slot_index] == -1:
		select_spell()
	else:
		display_spell()
func select_spell():
	#var filtered_cards = unfiltered_cards #SUBDECK OR SOMETHING TO FILTER
	var card_to_display:SpellCard = filtered_cards.find_first_allowed()
	card_to_display.select(player_index,context,spell_slot_index)
	if unfiltered_cards.select(card_to_display):
		print("Succesfull")
	else:
		printerr("card found not available")
	display_spell()
	
func display_spell():
	var displayed_card = to_display.instantiate()
	add_child(displayed_card)
	var card_index = GameManager.players[player_index]['selected_spells'][spell_slot_index]
	displayed_card.set_new_card(GameManager.universal_spell_deck.get_card(card_index))
	displayed_card.set_display_style(CardDisplay.DisplayStyle.DISPLAYING)

func highlight(new_state:bool):
	if new_state:
		theme_type_variation = "Panel2"
	else:
		theme_type_variation = "ClearPanelContainer"

func apply_filter():
	print("Applying filter")
	match filter_type:
		Filter_Types.EXCLUDE:
			filtered_cards = unfiltered_cards.filter(filter_strings,"EXCLUDE")
		Filter_Types.INCLUDE:
			filtered_cards = unfiltered_cards.filter(filter_strings,"INCLUDE")
		
func unlearn(check_card:Card):
	if get_child_count() > 0 and get_child(0).card == check_card:
		get_child(0).set_new_card(blank_card)
	
