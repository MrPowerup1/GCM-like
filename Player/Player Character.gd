extends CharacterBody2D
class_name Player

@export var health:int = 10
var can_release:Array[bool]=[true,true]
var facing:Vector2
var num_spells:int
@export var my_input:PlayerCharacterInput
@export var input_keys:Input_Keys
@export var spawn_loc:Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	position=spawn_loc
	my_input.button_activate.connect(activate)
	my_input.button_release.connect(release)
	my_input.input_keys=input_keys

func _physics_process(delta):
	#input vector from arrow keys
#	var direction = Vector2(Input.get_axis(input_keys.left, input_keys.right),Input.get_axis(input_keys.up,input_keys.down))
#	#really sloppy movement code right now
#	if can_move and direction:
#		velocity=velocity* (100-temp_friction)/100
#		velocity+= direction * temp_speed
#	else:
#		velocity = velocity* (100-temp_friction)/100
#		#velocity = velocity.move_toward(Vector2.ZERO, speed)
	if %Velocity.can_move and !velocity.is_zero_approx():
		#facing=velocity.normalized()
		facing=velocity.normalized().snapped(Vector2.ONE)
		#pass
	
#	if (Input.is_action_just_pressed(input_keys.spell1)):
#		activate(0)
#	if can_release[0] and (Input.is_action_just_released(input_keys.spell1)):
#		release(0)
#	if (Input.is_action_just_pressed(input_keys.spell2)):
#		activate(1)
#	if can_release[1] and (Input.is_action_just_released(input_keys.spell2)):
#		release(1)
#	move_and_slide()
func activate(index:int):
	%"Spell Manager".activate(index)
	
func release(index:int):
	if can_release[index]:
		%"Spell Manager".release(index)
	
func add_status_effect(status:Status_Type,caster:Player):
	%"Status Manager".new_status(status,caster)

func take_damage (amount:int):
	health-=amount
	#print ("Damaged down to ",health)
	
func anchor (set_anchor:bool=true):
	%Velocity.anchor(set_anchor)

func heal (amount:int):
	health+=amount
	#print ("Healed up to ", health)

func get_held_time(spell_index:int):
	if spell_index < num_spells:
		return %"Spell Manager".get_held_time(spell_index)
	else:
		return %"Status Manager".get_held_time(spell_index)

func set_sprite(new_sprite:Texture2D):
	%Sprite2D.texture=new_sprite
	
func set_release_permission(index:int, state:bool):
	can_release[index]=state

#func set_speed(new_speed:float=%Velocity.default_speed):
#	%Velocity.set_speed(new_speed)
#
#func set_friction(new_friction:float=%Velocity.default_friction):
#	%Velocity.set_friction(new_friction)
#
#func set_mass(new_mass:float=%Velocity.default_mass):
#	%Velocity.set_mass(new_mass)

func clear_status(index:int):
	%"Status Manager".clear_status(index-num_spells)
