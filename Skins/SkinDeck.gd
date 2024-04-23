extends Resource
class_name SkinDeck

@export var skins: Array[CharacterSkin]
@export var allowed: Array[bool]

func random() -> CharacterSkin:
	var index = randi_range(0,skins.size()-2)
	return skins[index]

func start_skins() -> Array:
	return next_skins(skins[0])

func next_skins(new_center_skin:CharacterSkin) -> Array:
	var new_center_index = skins.find(new_center_skin)
	var left_skin = skins[(new_center_index-1)%skins.size()]
	var right_skin = skins[(new_center_index+1)%skins.size()]
	var center_status = allowed[new_center_index]
	return [center_status,left_skin,new_center_skin,right_skin]
	
func select(skin:CharacterSkin) -> bool:
	var index = skins.find(skin)
	if allowed[index]:
		allowed[index] = false
		return true
	return false

func unselect(skin:CharacterSkin) -> bool:
	var index = skins.find(skin)
	if !allowed[index]:
		allowed[index] = true
		return true
	return false
