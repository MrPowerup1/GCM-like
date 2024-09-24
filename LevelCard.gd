extends Card
class_name LevelCard


@export var level:PackedScene

func select(player_index:int,context:CardContext):
	#TODO: Add functionality
	pass
	#player.set_skin(skin)

func unselect(player_index:int,context:CardContext):
	pass

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	#card.set_theme_type("Panel2")
	#card.set_shader_replacement_color(skin.color)
