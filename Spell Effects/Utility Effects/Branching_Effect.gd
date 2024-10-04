extends Positional_Effect
class_name Branching_Effect

enum Restriction_Types{EQUALS}
@export var restriction_type:Restriction_Types
@export var key:String
@export var values:Array[String]
@export var effects:Array[Spell_Effect]



func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):

	if restriction_type==Restriction_Types.EQUALS:
		var index = check_data(caster,spell_index)
		assert(index >= 0, str("Cant find value of type ",key))
		trigger_spell(index,target,caster,spell_index,location)

func check_data(caster:Player,spell_index:int)->int:
	var data = caster.get_spell_data(spell_index,key)
	if data == null:
		return -1
	for i in range(values.size()):
		if data == values[i]:
			return i
	return -1

func trigger_spell(index:int,target,caster:Player,spell_index:int,location:SGFixedVector2=target.fixed_position):
	if (effects[index] is Positional_Effect):
		(effects[index] as Positional_Effect).trigger(target,caster,spell_index,location)
	else:
		effects[index].trigger(target,caster,spell_index)
