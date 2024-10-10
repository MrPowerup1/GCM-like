extends Card
class_name SpellCard

@export var spell:Spell
@export var element:Element
@export var requirements:Array[Element] = []
#Should be bitflags
enum Categories {None,Melee,Mobility}
#var category
@export var category:Categories
@export_enum("Buff","Movement","Attack","Defense") var type:int
@export var randomizer = false

#@export var context:CardContext

func select(player_index:int,context:CardContext):
	if context == CardContext.SELECTING:
		GameManager.players[player_index]['selected_spells'].append(GameManager.universal_spell_deck.get_index(self))
	elif context == CardContext.LEARNING:
		GameManager.players[player_index]['known_spells'].append(GameManager.universal_spell_deck.get_index(self))

func unselect(player_index:int,context:CardContext):
	if context == CardContext.SELECTING:
		GameManager.players[player_index]['selected_spells'].erase(GameManager.universal_spell_deck.get_index(self))
	elif context == CardContext.LEARNING:
		GameManager.players[player_index]['known_spells'].erase(GameManager.universal_spell_deck.get_index(self))
	

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	#card.set_theme_type("SpellPanel")
