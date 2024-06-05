extends Positional_Effect
class_name Delayed_Cast_Effect

@export var delay_time:int
@export var effect:Spell_Effect
@export var delayed_cast_instance:PackedScene = preload("res://Instanced Scenes/delayed_cast_instance.tscn")


func trigger(target,caster:Player, spell_index:int,position:SGFixedVector2=caster.fixed_position):
	#TODO:This is broken in rollback
	print(caster)
	SyncManager.spawn("Delayed_effect",caster.get_parent().get_parent(),delayed_cast_instance,
	{target=target,caster=caster,spell_index=spell_index,position_x=position.x,position_y=position.y,effect=effect,delay_time=delay_time})
