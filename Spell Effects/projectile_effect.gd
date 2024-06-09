extends Positional_Effect
class_name Projectile_Effect


@export var projectile_scene:PackedScene
@export var projectile_sprite:Texture2D
@export var speed:int
@export var piercing:bool
@export var lifetime:int
@export var on_hit_effect:Spell_Effect #could be damage or could be spawning a wall
@export var on_hit_self:Spell_Effect
@export var on_timeout_self:Spell_Effect

#func _network_spawn(data: Dictionary) -> void:
	#print("Spawning")
	#fixed_position_x=data['position'].x
	#fixed_position_y=data['position'].y
	#caster = get_node(data['caster_path'])
	#if data.has('hit_effect_path'):
		#hit_effect=load(data['hit_effect_path'])
	#if data.has('self_effect_on_hit_path'):
		#self_effect_on_hit=load(data['self_effect_on_hit_path'])
	#if data.has('self_effect_on_timeout_path'):
		#self_effect_on_timeout=load(data['self_effect_on_timeout_path'])
	#if data.has('img_path'):
		#get_node("Sprite2D").texture = load(data['img_path'])
	#%Timer.wait_ticks=data['life_time']
	#%Timer.start()
	#sync_to_physics_engine()
	#velocity.default_speed=data['speed']
	#start_moving()
#spd:int,img:Texture2D,effect:Spell_Effect,lifetime:float,size:Vector2,cast:Player,pierce:bool,on_timeout:Spell_Effect=null,on_hit:Spell_Effect=null
func trigger(target,caster:Player,spell_index:int,location:SGFixedVector2=caster.fixed_position):
	var new_projectile = SyncManager.spawn('Projectile',caster.get_parent().get_parent(),projectile_scene,{
		'position'=location,
		'caster'=caster,
		'img'=projectile_sprite,
		'life_time'=lifetime,
		'hit_effect'=on_hit_effect,
		'self_effect_on_hit'=on_hit_self,
		'self_effect_on_timeout'=on_timeout_self,
		'speed'=speed,
		'piercing'=piercing,
		
	})
	return new_projectile
