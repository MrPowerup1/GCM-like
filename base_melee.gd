extends Area2D
class_name melee

@export var speed=100.0
@export var piercing:bool
var facing:Vector2
@export var hit_effect:Spell_Effect
@export var self_effect_on_hit:Spell_Effect
@export var self_effect_on_timeout:Spell_Effect
var caster:Player
var animation:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation_degrees+=speed*delta

func initialize(spd:int,img:Texture2D,effect:Spell_Effect,lifetime:float,size:Vector2,cast:Player,pierce:bool,on_timeout:Spell_Effect=null,on_hit:Spell_Effect=null):
	speed=spd
	get_node("Sprite2D").texture=img
	%Timer.wait_time=lifetime
	scale=size
	hit_effect=effect
	%Timer.start()
	piercing=pierce
	animation.play("Sword_Anim")
	


func _on_timer_timeout():
	if (self_effect_on_timeout!=null):
		self_effect_on_timeout.trigger(caster,-1)
	queue_free()


func _on_body_entered(body):
	if (hit_effect!=null):
		hit_effect.trigger(body,-1)
	if (self_effect_on_hit!=null):
		self_effect_on_hit.trigger(caster,-1)
	if (!piercing):
		queue_free()
