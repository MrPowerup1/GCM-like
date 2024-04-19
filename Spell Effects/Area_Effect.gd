extends Positional_Effect
class_name Area_Effect

@export var image:Texture2D
@export var on_enter:Spell_Effect
@export var on_exit:Spell_Effect
@export var on_ping:Spell_Effect
@export var call_exit_on_timeout:bool
@export var area_scene:PackedScene
@export_category("Time (in ms)")
@export var life_time:int
@export var ping_time:int

#func initialize(cast:Player,img:Texture2D,life_time:int,ping_time:int,enter:Spell_Effect,exit:Spell_Effect,ping:Spell_Effect,trigger_exit_on_timeout:bool):
func trigger (target,caster:Player,spell_index:int,location:Vector2=caster.position):
	var new_area=area_scene.instantiate()
	caster.get_parent().add_child(new_area)
	new_area.position=location
	new_area.initialize(caster,image,life_time,ping_time,on_enter,on_exit,on_ping,call_exit_on_timeout)
	return new_area
