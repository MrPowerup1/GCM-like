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
func trigger (target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	var new_area = SyncManager.spawn('Area',caster.get_parent().get_parent(),area_scene,{
		'position'=location,
		'caster'=caster,
		'img'=image,
		'life_time'=life_time,
		'ping_time'=ping_time,
		'enter'=on_enter,
		'exit'=on_exit,
		'ping'=on_ping,
		'trigger_exit_on_timeout'=call_exit_on_timeout
	})
	return new_area
