extends Positional_Effect
class_name Projectile_Effect

@export_category ("JUST USE AREA NOT PROJECTILE")
enum effect_time {ON_HIT,ON_TIMEOUT,ON_PING,ON_SPAWN}
enum effect_location {CASTER,TARGET,PROJECTILE}
@export var timings:Array[effect_time]
@export var locations:Array[effect_location]
@export var effects:Array[Spell_Effect]
#the held function will be called repeatedly while still held, based on timer
@export var ping_time:int
@export var life_time:int
@export var speed:int
@export var piercing:bool

@export var projectile_scene:PackedScene




func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	var new_projectile = SyncManager.spawn('Projectile',caster.get_parent().get_parent(),projectile_scene,{
		'position'=location,
		'caster'=caster,
		'spell_index'=spell_index
	})
	return new_projectile
