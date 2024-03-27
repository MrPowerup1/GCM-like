extends Spell_Effect
class_name Projectile_Effect


@export var projectile_scene:PackedScene
@export var projectile_sprite:Texture2D
@export var speed:int
@export var size:Vector2
@export var lifetime:float
@export var cooldown:float
@export var on_hit_effect:Spell_Effect #could be damage or could be spawning a wall

func trigger(caster:Player,spell_index:int):
	var new_projectile=projectile_scene.instantiate()
	caster.get_parent().add_child(new_projectile)
	new_projectile.transform=caster.transform
	new_projectile.move_dir=caster.facing
	new_projectile.initialize(speed,projectile_sprite,on_hit_effect,lifetime,size)

