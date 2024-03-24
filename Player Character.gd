extends CharacterBody2D
class_name Player

@export_range(0,100,1) var speed=0
@export_range(0,100,1) var friction_percent=10
@export var projectile_scene : PackedScene
var active_spells:Array[Base_Spell] = []
var learned_spells:Array[Base_Spell] = []
var can_move:bool = true

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	#input vector from arrow keys
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up","ui_down"))
	#really sloppy movement code right now
	if can_move and direction:
		velocity=velocity* (100-friction_percent)/100
		velocity+= direction * speed
	else:
		velocity = velocity* (100-friction_percent)/100
		#velocity = velocity.move_toward(Vector2.ZERO, speed)
	if (Input.is_action_pressed("ui_accept")):
		activate(0)
	if (Input.is_action_pressed("ui_text_backspace")):
		
		activate(1)
	move_and_slide()
func activate(index:int):
	if(active_spells.size()>index and active_spells[index]!=null):
		active_spells[index].activate(self)
func add_spell(new_spell:Base_Spell):
	learned_spells.append(new_spell)
	#replace with spell selection later
	active_spells.append(new_spell)
	
