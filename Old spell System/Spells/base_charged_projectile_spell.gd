extends Base_Projectile_Spell
class_name Base_Charged_Projectile_Spell


var charge_time:float
var anchor_when_charging:bool
var can_end_early:bool
var disable_other_spells:bool
var current_projectile
var charging:bool
var current_charge_time:float
var this_spell: Charge_Projectile_Spell
var caster:Player

#Called by Actions on ready to copy info from spell resource to this scene
func initialize(spell:Spell):
	saveBaseSpellStats(spell)
	saveProjectileSpellStats(spell)
	saveChargedSpellStats(spell)
	this_spell=spell
	
	
func saveChargedSpellStats(spell:Charge_Spell):
	charge_time=spell.charge_time
	anchor_when_charging=spell.anchor_when_charging
	can_end_early=spell.can_end_early
	disable_other_spells=spell.can_end_early
	current_charge_time=0
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !charging:
		current_cooldown-=delta
	if charging:
		current_charge_time-=delta
	if current_charge_time <0:
		fire()
	if current_projectile!=null:
		update_projectile()

func activate(current_caster:Player):
	if (current_cooldown<0):
		caster=current_caster
		if (anchor_when_charging):
			caster.can_move=false
		charging=true
		current_charge_time=charge_time
		current_cooldown=max_cooldown
		current_projectile = projectile_scene.instantiate()
		caster.get_parent().add_child(current_projectile)
		current_projectile.transform=caster.transform
		current_projectile.move_dir=caster.velocity.normalized()
		current_projectile.initialize(speed,projectile_sprite,damage,lifetime,size,true)
		#print(current_projectile.paused)

func fire():
	
	var charge_ratio = (charge_time-maxf(current_charge_time,0))/charge_time
	current_cooldown=max_cooldown*this_spell.cooldown_factor.sample_baked(charge_ratio)
	current_projectile.initialize(speed*this_spell.speed_factor.sample(charge_ratio),projectile_sprite,damage*this_spell.damage_factor.sample(charge_ratio),lifetime*this_spell.lifetime_factor.sample(charge_ratio),size*this_spell.size_factor.sample(charge_ratio))
	current_charge_time=charge_time
	charging=false
	if (anchor_when_charging):
			caster.can_move=true
	current_projectile=null
	
func update_projectile():
	var charge_ratio = (charge_time-maxf(current_charge_time,0))/charge_time
	current_projectile.set_size(size*this_spell.size_factor.sample(charge_ratio))
	
