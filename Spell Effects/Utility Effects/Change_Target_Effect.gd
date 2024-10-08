extends Positional_Effect
class_name Change_Target_Effect

enum New_Target_Types {CASTER,LOAD_FROM_DATA}
@export var new_target_type:New_Target_Types
@export var effect:Spell_Effect
@export_category("Optional")
@export var update_position_with_target_change:bool = true
@export var key:String

func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	if new_target_type==New_Target_Types.LOAD_FROM_DATA:
		var new_target = caster.get_spell_data(spell_index,key)
		assert (new_target != null,str("Target at key value: ",key," was null"))
		if update_position_with_target_change:
			location = new_target.fixed_position
		trigger_effect(new_target,caster,spell_index,location)
	elif new_target_type==New_Target_Types.CASTER:
		var new_target = caster
		trigger_effect(new_target,caster,spell_index,location)

func trigger_effect(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	if (effect is Positional_Effect):
		(effect as Positional_Effect).trigger(target,caster,spell_index,location)
	else:
		effect.trigger(target,caster,spell_index)
