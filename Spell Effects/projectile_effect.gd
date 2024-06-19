extends Positional_Effect
class_name Projectile_Effect

@export_category ("Main Effects")
enum effect_time {ON_HIT,ON_TIMEOUT,ON_PING}
enum effect_location {CASTER,TARGET,PROJECTILE}
@export var timings:Array[effect_time]
@export var locations:Array[effect_location]
@export var effects:Array[Spell_Effect]

@export_category("Old for compatibility")
@export var on_hit_effect:Spell_Effect #could be damage or could be spawning a wall
@export var on_hit_self:Spell_Effect
@export var on_timeout_self:Spell_Effect
#the held function will be called repeatedly while still held, based on timer
@export var ping_time:int
@export var life_time:int
@export var speed:int
@export var piercing:bool

@export var projectile_scene:PackedScene
@export var projectile_sprite:Texture2D




func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	var new_projectile = SyncManager.spawn('Projectile',caster.get_parent().get_parent(),projectile_scene,{
		'position'=location,
		'caster'=caster,
		'img'=projectile_sprite,
		'life_time'=life_time,
		'timings'=timings,
		'locations'=locations,
		'effects'=effects,
		'ping_time'=ping_time,
		'hit_effect'=on_hit_effect,
		'self_effect_on_hit'=on_hit_self,
		'self_effect_on_timeout'=on_timeout_self,
		'speed'=speed,
		'piercing'=piercing
	})
	return new_projectile
