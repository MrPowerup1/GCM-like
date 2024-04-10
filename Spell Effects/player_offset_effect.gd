extends Spell_Effect
class_name Player_Offset_Effect

@export var offset:Vector2
@export var effect:Positional_Effect

func trigger(caster:Player,spell_index:int):
	effect.trigger(caster,spell_index,caster.position+offset.rotated(caster.facing.angle()))
