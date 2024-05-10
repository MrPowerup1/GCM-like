extends Node
class_name Velocity

const fixed_point_factor = 65536

var velocity:SGFixedVector2 = SGFixedVector2.new()
@export var body:Node2D
@export var stop_input_at_max_vel:bool
@export var max_input_vel_square:int

@export var speed:int
var default_speed:int
@export var friction:int
var default_friction:int
@export var mass:int = 1
var default_mass:int
var can_move:bool=true

var anchored_pos:Vector2

func _ready():
	velocity.from_float(Vector2.ZERO)
	speed*=fixed_point_factor
	friction*=fixed_point_factor
	default_speed=speed
	default_friction=friction
	default_mass=mass
	if body==null:
		body=get_parent()
func pulse_to(direction,strength: float):
	var pulse_dir = SGFixedVector2.new()
	if (direction is Vector2):
		pulse_dir.from_float((direction-body.position).normalized())
	elif (direction is float):
		pulse_dir.from_float(Vector2.from_angle(direction))
	elif (direction is Node2D):
		pulse_dir.from_float((direction.position-body.position).normalized())
	else:
		printerr("Cannot pulse to direction of type ",direction.name)
	velocity.iadd(pulse_dir.mul(strength/mass))
func pulse_from(direction,strength: float):
	var pulse_dir = SGFixedVector2.new()
	if (direction is Vector2):
		pulse_dir.from_float((direction-body.position).normalized())
	elif (direction is float):
		pulse_dir.from_float(Vector2.from_angle(direction))
	elif (direction is Node2D):
		pulse_dir.from_float((direction.position-body.position).normalized())
	else:
		printerr("Cannot pulse from direction of type ",direction.name)
	velocity.isub(pulse_dir.mul(strength/mass))

func move_input(direction:SGFixedVector2):
	print("Input in direction")
	print(direction.to_float())
	var add_to_vel = direction
	add_to_vel.imul(speed/mass)
	print(add_to_vel.to_float())
	if can_move and direction!=null:
		if !stop_input_at_max_vel:
			print("here 1")
			velocity.iadd(add_to_vel)
		elif stop_input_at_max_vel and velocity.length_squared()<max_input_vel_square:
			print("Here 2")
			velocity.iadd(add_to_vel)
	else:
		pass

func constant_vel(direction:Vector2):
	friction=0
	velocity.from_float(direction*speed)

func anchor(set_anchor:bool=false):
	can_move=!set_anchor
	velocity.from_float(Vector2.ZERO)
	anchored_pos=body.position

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
	#print("Trying to move speed ")
	#print (velocity.to_float())
	if velocity.length_squared()>friction*delta:
		print("Velocity sufficient to overcome friction")
		velocity.isub(velocity.normalized().mul(friction*delta))
	else:
		velocity.from_float(Vector2.ZERO)
	if body!=null:
		if (body is SGCharacterBody2D):
			body.velocity=velocity
			body.move_and_slide()
			velocity=body.velocity
		else:
			body.position+=velocity*delta
	if can_move==false:
		body.position=body.position.lerp(anchored_pos,0.5)
	
