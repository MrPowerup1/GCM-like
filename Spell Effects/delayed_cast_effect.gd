extends Positional_Effect
class_name Delayed_Cast_Effect

@export var delay_time:int
@export var effect:Spell_Effect
@export var delayed_cast_instance:PackedScene = preload("res://Instanced Scenes/delayed_cast_instance.tscn")
enum OriginType {target,caster}
@export var origin:OriginType = OriginType.target


func trigger(target,caster:Player, spell_index:int,position:SGFixedVector2=caster.fixed_position):
	#TODO:This is broken in rollback
	var parent
	if origin == OriginType.target:
		if target.has_node("Delayed Casts"):
			parent = target.get_node("Delayed Casts")
		else:
			parent = target
	elif origin == OriginType.caster:
		if caster.has_node("Delayed Casts"):
			parent = caster.get_node("Delayed Casts")
		else:
			parent = caster
	SyncManager.spawn("Delayed_effect",parent,delayed_cast_instance,
	{target=target,caster=caster,spell_index=spell_index,position_x=position.x,position_y=position.y,effect=effect,delay_time=delay_time})
