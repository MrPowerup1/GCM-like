extends Positional_Effect
class_name Player_Offset_Effect

@export var offset:Vector2
@export var effect:Positional_Effect
var fixed_offset:SGFixedVector2 = SGFixedVector2.new()
func trigger(target,caster:Player,spell_index:int,position:SGFixedVector2=target.fixed_position):
	fixed_offset.from_float(offset)
	effect.trigger(target,caster,spell_index,position.add(fixed_offset.rotated(caster.facing.angle())))
