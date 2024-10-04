extends Positional_Effect
class_name Multi_Spell_Effect

@export var effects:Array[Spell_Effect] = []
	
func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	for i in range(effects.size()):
		trigger_spell(i,target,caster,spell_index,location)

func trigger_spell(index:int,target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	if (effects[index] is Positional_Effect):
		(effects[index] as Positional_Effect).trigger(target,caster,spell_index,location)
	else:
		effects[index].trigger(target,caster,spell_index)
