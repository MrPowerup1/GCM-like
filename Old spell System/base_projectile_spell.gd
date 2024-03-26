extends Base_Spell
class_name Base_Projectile_Spell

var projectile_sprite:Texture2D
var damage:int
var speed:int
var size:Vector2
var projectile_scene:PackedScene
var lifetime:float
var max_cooldown:float
var current_cooldown:float

#Called by Actions on ready to copy info from spell resource to this scene
func initialize(spell : Spell):
	saveBaseSpellStats(spell)
	saveProjectileSpellStats(spell)
	
	
func saveProjectileSpellStats(spell:Spell):
	projectile_sprite=spell.projectile_sprite
	damage=spell.damage
	speed=spell.speed
	lifetime=spell.lifetime
	max_cooldown=spell.cooldown
	current_cooldown=0
	projectile_scene=spell.projectile_scene
	size=spell.size
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_cooldown-=delta

func activate(caster:Player):
	if (current_cooldown<0):
		current_cooldown=max_cooldown
		var new_projectile = projectile_scene.instantiate()
		caster.get_parent().add_child(new_projectile)
		new_projectile.transform=caster.transform
		new_projectile.move_dir=caster.velocity.normalized()
		new_projectile.initialize(speed,projectile_sprite,damage,lifetime,size)
	
func deactivate(caster:Player):
	pass
