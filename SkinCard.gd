extends Card
class_name SkinCard

@export var skin:CharacterSkin

func select(player_index:int):
	var data = GameManager.players[player_index]
	data['selected_skin'] = GameManager.universal_skin_deck.get_index(self)

func unselect(player_index:int):
	pass

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	card.set_theme_type("Panel2")
	card.set_shader_replacement_color(skin.color)
