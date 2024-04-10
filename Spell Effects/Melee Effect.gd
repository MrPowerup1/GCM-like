extends Spell_Effect
class_name Melee_Effect
#Currently Non Functional


@export var melee_scene:PackedScene
@export var weapon_sprite:Texture2D
@export var speed:int
@export var piercing:bool
@export var size:Vector2
@export var lifetime:float
@export var on_hit_effect:Spell_Effect #could be damage or could be spawning a wall
@export var on_hit_self:Spell_Effect
@export var on_timeout_self:Spell_Effect
@export var held_distance:float

#spd:int,img:Texture2D,effect:Spell_Effect,lifetime:float,size:Vector2,cast:Player,pierce:bool,on_timeout:Spell_Effect=null,on_hit:Spell_Effect=null
func trigger(caster:Player,spell_index:int):
	var new_melee=melee_scene.instantiate()
	caster.get_parent().add_child(new_melee)
	new_melee.transform=caster.transform
	new_melee.move_dir=caster.facing
	new_melee.position+=new_melee.move_dir*held_distance
	new_melee.initialize(speed,weapon_sprite,on_hit_effect,lifetime,size,caster,piercing,on_timeout_self,on_hit_self)

