extends Node
class_name Velocity

var velocity:Vector2 = Vector2.ZERO
@export var character:CharacterBody2D
@export var max_input_vel_square:float
#Currently unused
@export_range(100,200.0) var zero_velocity_range_square:float
@export var speed:float
var default_speed:float
@export var friction:float
var default_friction:float
@export var mass:float = 1
var default_mass:float
var can_move:bool=true

func _ready():
	default_speed=speed
	default_friction=friction
	default_mass=mass
func pulse_to(direction,strength: float):
	if (direction is Vector2):
		print("Pulsing toward ", direction)
		print("Position is ",character.position)
		velocity+=(direction-character.position).normalized()*strength/mass
	elif (direction is float):
		velocity+=Vector2.from_angle(direction)*strength/mass
	elif (direction is Node2D):
		velocity+=(direction.position-character.position).normalized()*strength/mass
	else:
		printerr("Cannot pulse to direction of type ",direction.name)
	
func pulse_from(direction,strength: float):
	if (direction is Vector2):
		velocity-=(direction-character.position).normalized()*strength/mass
	elif (direction is float):
		velocity-=Vector2.from_angle(direction)*strength/mass
	elif (direction is Node2D):
		velocity-=(direction.position-character.position).normalized()*strength/mass
	else:
		printerr("Cannot pulse from direction of type ",direction.name)

func move_input(direction:Vector2,delta:float):
	if velocity.length_squared()<max_input_vel_square and can_move and direction!=null:
		velocity+=direction*speed*delta/mass
	else:
		pass

func anchor(set_anchor:bool=false):
	can_move=!set_anchor
	velocity=Vector2.ZERO
	#print("Setting Anchor to ",set_anchor)

func set_speed(new_speed:float=default_speed):
	speed=new_speed

func set_friction(new_friction:float=default_friction):
	friction=new_friction

func set_mass(new_mass:float=default_mass):
	mass=new_mass

func reset_stats():
	anchor()
	set_friction()
	set_mass()
	set_speed()

func _physics_process(delta):
	if velocity.length()>friction*delta:
		velocity -= velocity.normalized()*friction*delta
	else:
		velocity=Vector2.ZERO
#	if (velocity.length_squared()<zero_velocity_range_square):
#		velocity=Vector2.ZERO
	character.velocity=velocity
	character.move_and_slide()
	
