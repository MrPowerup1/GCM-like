extends Positional_Effect
class_name Control_Effect

@export var effect_to_control:Spell_Effect
@export var save_until_release:bool

func trigger(target,caster:Player,spell_index:int,position:SGFixedVector2=target.fixed_position):
	var returned_target=null
	if effect_to_control is Positional_Effect:
		returned_target=(effect_to_control as Positional_Effect).trigger(target,caster,spell_index,position)
	else:
		returned_target= effect_to_control.trigger(target,caster,spell_index)
	var caster_control = caster.get_node("PlayerCharacterInput")
	if caster_control == null:
			return
	if (returned_target !=null and returned_target is Node2D and (returned_target as Node2D).has_node("Velocity")):
		var to_control=(returned_target as Node2D).get_node("Velocity")
		caster_control.velocity = to_control
		if save_until_release:
			await caster.spell_released
			if (returned_target!=null):
				returned_target.release.rpc()
