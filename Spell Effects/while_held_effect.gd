extends Positional_Effect
class_name While_Held_Effect

@export var effect_to_control:Spell_Effect

func trigger(target,caster:Player,spell_index:int,position:Vector2=target.position):
	var returned_target=null
	if effect_to_control is Positional_Effect:
		returned_target=(effect_to_control as Positional_Effect).trigger(target,caster,spell_index,position)
	else:
		returned_target= effect_to_control.trigger(target,caster,spell_index)
	if returned_target!=null:
		await caster.spell_released
		returned_target.release()
		
