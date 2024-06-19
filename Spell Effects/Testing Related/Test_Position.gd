extends Positional_Effect
class_name Test_Position

func trigger(target,caster:Player,spell_index:int,position:SGFixedVector2=caster.fixed_position):
	print (position.to_float())
