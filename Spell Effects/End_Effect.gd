extends Spell_Effect
class_name End_Effect

func trigger(target,caster:Player,spell_index:int):
	target.can_release[spell_index]=true
	target.release(spell_index)
