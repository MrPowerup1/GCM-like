extends Spell_Effect
class_name End_Effect

func trigger(target,caster:Player,spell_index:int):
	target.release(spell_index)
