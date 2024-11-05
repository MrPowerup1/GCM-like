extends PanelContainer

@export var do_filter:bool
enum Filter_Types {Exclude,Include}
@export var filter_type:Filter_Types
@export var filter_strings:Array[String]
var unfiltered_cards:Deck
@export var to_display:PackedScene = load("res://UI/CardDisplay.tscn")
@export var context:Card.CardContext
@export var spell_slot_index:int
var player_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_deck(new_deck:Deck):
	unfiltered_cards = new_deck
	if get_child_count() > 0:
		pass
	else:
		select_spell()
	
func select_spell():
	var filtered_cards = unfiltered_cards #SUBDECK OR SOMETHING TO FILTER
	var card_to_display:SpellCard = filtered_cards.find_first_allowed()
	card_to_display.select(player_index,context,spell_slot_index)
	if unfiltered_cards.select(card_to_display):
		print("Succesfull")
	else:
		printerr("card found not available")
	var displayed_card = to_display.instantiate()
	add_child(displayed_card)
	displayed_card.set_new_card(card_to_display)
	displayed_card.set_display_style(CardDisplay.DisplayStyle.DISPLAYING)
	
