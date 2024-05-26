extends Resource
class_name Card

@export var name:String
@export var image:Texture2D
@export var description:String
enum CardContext {LEARNING,SELECTING}
@export var context:CardContext

func select(player_index:int):
	printerr ("Selected a base card, (IDK WHAT TO DO)")
	pass

func unselect(player_index:int):
	printerr ("Selected a base card, (IDK WHAT TO DO)")
	pass

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	card.set_theme_type("")
