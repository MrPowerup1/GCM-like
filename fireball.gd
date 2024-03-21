extends Area2D

@export var speed=100.0
var move_dir:Vector2
@export var lifetime=2.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position+=move_dir*speed*delta
	lifetime-=delta
	if lifetime<=0:
		queue_free()
