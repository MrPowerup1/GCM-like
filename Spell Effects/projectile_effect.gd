extends Positional_Effect
class_name Projectile_Effect


@export var projectile_scene:PackedScene
@export var projectile_sprite:Texture2D
@export var speed:int
@export var piercing:bool
@export var size:Vector2
@export var lifetime:int
@export var on_hit_effect:Spell_Effect #could be damage or could be spawning a wall
@export var on_hit_self:Spell_Effect
@export var on_timeout_self:Spell_Effect

#spd:int,img:Texture2D,effect:Spell_Effect,lifetime:float,size:Vector2,cast:Player,pierce:bool,on_timeout:Spell_Effect=null,on_hit:Spell_Effect=null
func trigger(caster:Player,spell_index:int,location:Vector2=caster.position):
	var new_projectile=projectile_scene.instantiate()
	caster.get_parent().add_child(new_projectile)
	new_projectile.position=location
	new_projectile.initialize(speed,projectile_sprite,on_hit_effect,lifetime,size,caster,piercing,on_timeout_self,on_hit_self)

