extends CharacterBody2D

@export_range(0,100,1) var speed=0
@export_range(0,100,1) var friction_percent=10
@export var projectile_scene : PackedScene
@export var cooldown=2.0
var current_cooldown=cooldown	
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	#input vector from arrow keys
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up","ui_down"))
	#really sloppy movement code right now
	if direction:
		velocity=velocity* (100-friction_percent)/100
		velocity+= direction * speed
	else:
		velocity = velocity* (100-friction_percent)/100
		#velocity = velocity.move_toward(Vector2.ZERO, speed)
	current_cooldown-=delta
	if (current_cooldown<=0 and Input.is_action_pressed("ui_accept")):
		current_cooldown=cooldown
		shoot()
	move_and_slide()
func shoot():
	var fireball = projectile_scene.instantiate()
	get_parent().add_child(fireball)
	fireball.transform=transform
	fireball.move_dir=velocity.normalized()
