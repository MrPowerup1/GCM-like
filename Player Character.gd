extends CharacterBody2D
class_name Player

@export_range(0,100,1) var speed=0
@export_range(0,100,1) var friction_percent=10
#var active_spells:Array[Base_Spell] = []
#var learned_spells:Array[Base_Spell] = []
var can_move:bool = true
@export var health:int = 10
var can_release:Array[bool]=[true,true]
var facing:Vector2
var num_spells:int
var temp_speed:int
var temp_friction:int

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	temp_speed=speed
	temp_friction=friction_percent

func _physics_process(delta):
	#input vector from arrow keys
	var direction = Vector2(Input.get_axis("Left", "Right"),Input.get_axis("Up","Down"))
	#really sloppy movement code right now
	if can_move and direction:
		velocity=velocity* (100-temp_friction)/100
		velocity+= direction * temp_speed
	else:
		velocity = velocity* (100-temp_friction)/100
		#velocity = velocity.move_toward(Vector2.ZERO, speed)
	if can_move and velocity!= Vector2.ZERO:
		facing=velocity.normalized()
	
	if (Input.is_action_just_pressed("Spell1")):
		activate(0)
	if can_release[0] and (Input.is_action_just_released("Spell1")):
		release(0)
	if (Input.is_action_just_pressed("Spell2")):
		activate(1)
	if can_release[1] and (Input.is_action_just_released("Spell2")):
		release(1)
	move_and_slide()
func activate(index:int):
	%"Spell Manager".activate(index)
	

func release(index:int):
	print ("player character releasing ",index)
	%"Spell Manager".release(index)

func add_spell(new_spell:Base_Spell):
	%"Spell Manager".learn_spell(new_spell)
	
func add_status_effect(status:Status_Type,caster:Player):
	%"Status Manager".new_status(status,caster)
func take_damage (amount:int):
	health-=amount
	#print ("Damaged down to %i" [health])
	
func anchor (set_anchor:bool=true):
	velocity=Vector2.ZERO
	can_move=!set_anchor
	#print ("Anchored")

func heal (amount:int):
	health+=amount
	#print ("Healed up to %i" [health])

func get_held_time(spell_index:int):
	if spell_index < num_spells:
		return %"Spell Manager".get_held_time(spell_index)
	else:
		return %"Status Manager".get_held_time(spell_index)

func set_sprite(new_sprite:Texture2D):
	%Sprite2D.texture=new_sprite
	
func set_release_permission(index:int, state:bool):
	print ("Spell at index ", index," set to ",state)
	can_release[index]=state

func set_speed(new_speed:float=speed):
	temp_speed=new_speed

func set_friction(new_friction:float=friction_percent):
	temp_friction=new_friction
