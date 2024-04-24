extends Card
class_name SpellCard

@export var spell:Spell
@export var element:Element
@export var requirements:Array[Element] = []
@export_enum("Passive","Active") var category:int
@export_enum("Buff","Movement","Attack","Defense") var type:int
@export var randomizer = false

func select(player:PlayerManager):
	player.set_spell(spell)

func unselect(player:PlayerManager):
	player.set_spell(null)

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	card.set_theme_type("SpellPanel")
