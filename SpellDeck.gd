extends Resource
class_name SpellDeck

@export var spells: Array[Spell_Type]
@export var allowed: Array[bool]

func random() -> Spell_Type:
	var index = randi_range(0,spells.size()-2)
	return spells[index]

func start_spells() -> Array:
	return next_spells(spells[0])

func next_spells(new_center_spell:Spell_Type) -> Array:
	var new_center_index = spells.find(new_center_spell)
	var left_spell = spells[(new_center_index-1)%spells.size()]
	var right_spell = spells[(new_center_index+1)%spells.size()]
	var center_status = allowed[new_center_index]
	return [center_status,left_spell,new_center_spell,right_spell]
	
func select(spell:Spell_Type) -> bool:
	var index = spells.find(spell)
	if allowed[index]:
		allowed[index] = false
		return true
	return false

func unselect(spell:Spell_Type) -> bool:
	var index = spells.find(spell)
	if !allowed[index]:
		allowed[index] = true
		return true
	return false
