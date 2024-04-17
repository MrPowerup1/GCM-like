extends Area2D
class_name projectile

var speed=100.0
var move_dir:Vector2
var hit_effect:Spell_Effect
var self_effect_on_hit:Spell_Effect
var self_effect_on_timeout:Spell_Effect
var caster:Player
var piercing:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position+=move_dir*speed*delta

func initialize(spd:int,img:Texture2D,effect:Spell_Effect,lifetime:int,size:Vector2,cast:Player,pierce:bool,on_timeout:Spell_Effect=null,on_hit:Spell_Effect=null):
	speed=spd
	get_node("Sprite2D").texture=img
	if (lifetime>0):
		%Timer.wait_time=float(lifetime)/1000
		%Timer.start()
	else:
		printerr("Invalid Projectile Lifetime")
	scale=size
	hit_effect=effect
	
	caster=cast
	move_dir=caster.facing
	piercing=pierce
	self_effect_on_timeout=on_timeout
	self_effect_on_hit=on_hit
	

		
func set_size(size:Vector2):
	scale=size

func _on_timer_timeout():
	if (self_effect_on_timeout==null):
		pass
	elif (self_effect_on_timeout is Positional_Effect):
		(self_effect_on_timeout as Positional_Effect).trigger(caster,caster,-1,position)
	else:
		print(self_effect_on_timeout.is_class("Node"))
		print("activating base effect at caster")
		self_effect_on_timeout.trigger(caster,caster,-1)
	queue_free()


func _on_body_entered(body):
	if (hit_effect==null):
		pass
	elif (hit_effect is Positional_Effect):
		(hit_effect as Positional_Effect).trigger(body,caster,-1,position)
	else:
		hit_effect.trigger(body,caster,-1)
	if (self_effect_on_hit==null):
		pass
	elif (self_effect_on_hit is Positional_Effect):
		(self_effect_on_hit as Positional_Effect).trigger(caster,caster,-1,position)
	else:
		self_effect_on_hit.trigger(caster,caster,-1)
	if (!piercing):
		queue_free()
