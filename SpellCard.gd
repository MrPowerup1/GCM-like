extends Card
class_name SpellCard

@export var spell:Spell
@export var element:Element
@export var requirements:Array[Element] = []
@export_enum("Passive","Active") var category:int
@export_enum("Buff","Movement","Attack","Defense") var type:int
@export var randomizer = false

func select(player_index:int):
	GameManager.players[player_index]['selected_spells'].append(GameManager.universal_spell_deck.get_index(self))


func unselect(player_index:int):
	GameManager.players[player_index]['selected_spells'].erase(GameManager.universal_spell_deck.get_index(self))
	

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	card.set_theme_type("SpellPanel")
