extends Area2D
class_name projectile

var speed=100.0
var move_dir:Vector2
var damage:int
var lifetime=2.0
var paused:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!paused):
		position+=move_dir*speed*delta
		lifetime-=delta
		if lifetime<=0:
			queue_free()

func initialize(spd:int,img:Texture2D,dmg:int,lftme:float,size:Vector2,is_paused=false):
	speed=spd
	get_node("Sprite2D").texture=img
	damage=dmg
	lifetime=lftme
	scale=size
	paused=is_paused

func set_size(size:Vector2):
	scale=size
