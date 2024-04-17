extends Spell_Effect
class_name Status_Effect

@export var status:Status_Type

#for now caster is always target, but that should always be the case
func trigger(target,caster:Player,index:int):
	target.add_status_effect(status,caster)
