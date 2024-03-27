extends Spell_Effect
class_name End_Effect

func trigger(caster:Player,spell_index:int):
	caster.release(spell_index)
