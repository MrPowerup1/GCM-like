extends Card
class_name SkinCard

@export var skin:CharacterSkin

func select(player:PlayerManager):
	player.set_skin(skin)

func unselect(player:PlayerManager):
	pass

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	card.set_theme_type("Panel2")
	card.set_shader_replacement_color(skin.color)
