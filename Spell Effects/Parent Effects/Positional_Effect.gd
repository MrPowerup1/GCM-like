extends Spell_Effect
class_name Positional_Effect

var position:SGFixedVector2

func trigger (target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	position=location
