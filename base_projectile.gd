extends Area2D
class_name projectile

var speed=100.0
var move_dir:Vector2
var damage:int

var hit_effect:Spell_Effect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position+=move_dir*speed*delta

func initialize(spd:int,img:Texture2D,effect:Spell_Effect,lifetime:float,size:Vector2):
	speed=spd
	get_node("Sprite2D").texture=img
	%Timer.wait_time=lifetime
	scale=size
	print ("New Projectile of size ",size)
	hit_effect=effect
	%Timer.start()

		
func set_size(size:Vector2):
	scale=size

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if (hit_effect!=null):
		hit_effect.trigger(body,-1)
