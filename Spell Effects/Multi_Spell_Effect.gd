extends Spell_Effect
class_name Multi_Spell_Effect

@export var spells:Array[Spell_Effect] = []
	
func trigger(caster:Player,spell_index:int):
	for spell in spells:
		spell.trigger(caster,spell_index)
