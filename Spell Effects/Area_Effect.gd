extends Positional_Effect
class_name Area_Effect


#@export_category ("Main Effects")
#enum effect_time {ON_ENTER,ON_EXIT,ON_TIMEOUT,ON_PING,ON_SPAWN}
#enum effect_location {CASTER,TARGET,THIS_AREA}
#@export var timings:Array[effect_time]
#@export var locations:Array[effect_location]
#@export var effects:Array[Spell_Effect]
#
#
#@export var image:Texture2D
@export var area_scene:PackedScene
#@export_category("Time (in ms)")
#@export var life_time:int
#@export var ping_time:int

#func initialize(cast:Player,img:Texture2D,life_time:int,ping_time:int,enter:Spell_Effect,exit:Spell_Effect,ping:Spell_Effect,trigger_exit_on_timeout:bool):
func trigger (target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	var data_to_send = {
		'position'=location,
		'caster'=caster,
		'spell_index'=spell_index
		}
	#if image!=null:
		#data_to_send['img']=image
	#if life_time!=0:
		#data_to_send['life_time']=life_time
	#if ping_time!=0:
		#data_to_send['ping_time']=ping_time
	#if effects.size()!=0:
		#data_to_send['effects']=effects
	#if timings.size()!=0:
		#data_to_send['timings']=timings
	#if locations.size()!=0:	
		#data_to_send['locations']=locations
	var new_area = SyncManager.spawn('Area',caster.get_parent().get_parent(),area_scene,data_to_send)
	return new_area
