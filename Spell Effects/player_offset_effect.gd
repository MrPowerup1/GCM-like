extends Positional_Effect
class_name Player_Offset_Effect

@export var offset:Vector2
@export var effect:Positional_Effect

func trigger(target,caster:Player,spell_index:int,position:Vector2=target.position):
	effect.trigger(target,caster,spell_index,position+offset.rotated(caster.facing.angle()))
