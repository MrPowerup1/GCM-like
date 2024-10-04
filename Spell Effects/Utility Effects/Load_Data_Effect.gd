extends Positional_Effect
class_name Load_Data_Effect

enum Data_Types {TARGET,CASTER,LOCATION}
@export var data_type:Data_Types
@export var key:String
@export var effect:Spell_Effect
@export_category("Optional")
@export var update_position_with_target_change:bool = true

func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	if data_type==Data_Types.TARGET:
		var new_target = caster.get_spell_data(spell_index,key)
		assert (new_target != null,str("Target at key value: ",key," was null"))
		if update_position_with_target_change:
			location = new_target.fixed_position
		trigger_effect(new_target,caster,spell_index,location)
	#WHY WOULD THIS EVER GET USED?
	elif data_type==Data_Types.CASTER:
		var new_caster = caster.get_spell_data(spell_index,key)
		assert (new_caster is Player,str("Caster at key value: ",key," was not player"))
		trigger_effect(target,new_caster,spell_index,location)
	elif data_type==Data_Types.LOCATION:
		var new_location = caster.get_spell_data(spell_index,key)
		assert (new_location is SGFixedVector2,str("Location at key value: ",key," was not a position"))
		trigger_effect(target,caster,spell_index,new_location)

func trigger_effect(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	if (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,spell_index,location)
	else:
		effect.trigger(target,caster,spell_index)
