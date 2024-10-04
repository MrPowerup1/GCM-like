extends Spell_Effect
class_name Despawn_Effect

func trigger(target,caster:Player,spell_index:int):
	if target == null:
		pass
	elif target is Area:
		(target as Area).release()
	else:
		pass 
