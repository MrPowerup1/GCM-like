extends Resource
class_name Card

@export var name:String
@export var image:Texture2D
@export var description:String
@export var tags:Array[String]
enum CardContext {SELECTING,LEARNING,SACRIFICING}

func select(player_index:int,context:CardContext):
	printerr ("Player: ", player_index, " Selected a base card, (IDK WHAT TO DO)")
	pass

func unselect(player_index:int,context:CardContext):
	printerr ("Player: ", player_index, " Selected a base card, (IDK WHAT TO DO)")
	pass

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	#card.set_theme_type("")

func match_tags(check_tags:Array[String],match_type:String = "ANY")->bool:
	if check_tags.size()==0:
		return true
	match match_type:
		#If any of the strings match, return true
		"ANY":
			#Cant possibly match size 0
			if tags.size() == 0:
				return false
			for check_tag in check_tags:
				if tags.has(check_tag):
					return true
		#If all of the strings from check tags are present, return true
		"ALL":
			#Cant possibly match if there are fewer tags than check_tags
			if tags.size() < check_tags.size():
				return false
			for check_tag in check_tags:
				if tags.has(check_tag):
					pass
				else:
					return false
			return true
		var other:
			printerr("Match Tags Failed: unrecognized match type: ",other)
			return false
	return false
