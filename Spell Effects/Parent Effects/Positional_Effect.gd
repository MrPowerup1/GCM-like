extends Spell_Effect
class_name Positional_Effect

var position:Vector2

func trigger (target,caster:Player,spell_index:int,location:Vector2=caster.position):
	position=location
	print(position)
