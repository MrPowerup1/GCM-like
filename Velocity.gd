extends Node
class_name Velocity

const fixed_point_factor = 65536

var velocity:SGFixedVector2 = SGFixedVector2.new()
var facing:SGFixedVector2 = SGFixedVector2.new()
var fixed_zero =SGFixed.vector2(0,0)
@export var body:SGFixedNode2D
@export var stop_input_at_max_vel:bool
@export var max_input_vel:float
var max_input_vel_fixed:int

@export var speed:float
var speed_fixed:int
var default_speed:float
@export var friction:float
var friction_fixed:int
var default_friction:float
@export var mass:float = 1
var mass_fixed:int
var default_mass:float
var can_move:bool=true

var anchored_pos:SGFixedVector2

func _ready():
	velocity.from_float(Vector2.ZERO)
	speed_fixed=speed*fixed_point_factor
	friction_fixed=friction*fixed_point_factor
	mass_fixed=mass*fixed_point_factor
	default_speed=speed
	default_friction=friction
	default_mass=mass
	max_input_vel_fixed=max_input_vel*fixed_point_factor
	if body==null:
		body=get_parent()
func pulse_to(direction,strength: float):
	print("Pulsing to", direction)
	print("With strength",strength)
	var pulse_dir = SGFixedVector2.new()
	if (direction is Vector2):
		printerr('pulsing with a float is a no no I think')
		pulse_dir.from_float((direction-body.position).normalized())
	elif (direction is float):
		pulse_dir.from_float(Vector2.from_angle(direction))
	elif (direction is Node2D):
		pulse_dir.from_float((direction.position-body.position).normalized())
	elif (direction is SGFixedVector2):
		pulse_dir=direction.sub(body.fixed_position).normalized()
	else:
		printerr("Cannot pulse to direction of type ",direction.name)
	var fixed_strength:int = strength*fixed_point_factor
	print("Pre pulse",velocity.to_float())
	velocity.iadd(pulse_dir.mul(fixed_strength*fixed_point_factor/mass_fixed))
	print("Post pulse",velocity.to_float())
func pulse_from(direction,strength: float):
	print("Pulsing from", direction)
	print("With strength",strength)
	var pulse_dir = SGFixedVector2.new()
	if (direction is Vector2):
		pulse_dir.from_float((direction-body.position).normalized())
	elif (direction is float):
		pulse_dir.from_float(Vector2.from_angle(direction))
	elif (direction is Node2D):
		pulse_dir.from_float((direction.position-body.position).normalized())
	elif (direction is SGFixedVector2):
		print("Pulse from ",direction.to_float())
		pulse_dir=direction.sub(body.fixed_position).normalized()
	else:
		printerr("Cannot pulse from direction of type ",direction.name)
	var fixed_strength:int = strength*fixed_point_factor
	print("Pre pulse",velocity.to_float())
	velocity.isub(pulse_dir.mul(fixed_strength*fixed_point_factor/mass_fixed))
	print("Post pulse",velocity.to_float())

func move_input(direction:SGFixedVector2):
	if not direction.is_equal_approx(fixed_zero):
		facing = direction
	var add_to_vel = direction
	#print("Before",add_to_vel.to_float())
	#print("Multiplied by ",(speed_fixed/mass_fixed)/fixed_point_factor)
	add_to_vel.imul(speed_fixed/mass_fixed*fixed_point_factor)
	#print("After",add_to_vel.to_float())
	if can_move and direction!=null:
		if !stop_input_at_max_vel:
			velocity.iadd(add_to_vel)
		elif stop_input_at_max_vel and velocity.length()<max_input_vel_fixed:
			velocity.iadd(add_to_vel)
	else:
		pass

func constant_vel(direction:SGFixedVector2):
	friction=0
	friction_fixed=friction*fixed_point_factor
	velocity = direction.mul(speed_fixed)

func anchor(set_anchor:bool=false):
	can_move=!set_anchor
	velocity.from_float(Vector2.ZERO)
	anchored_pos=body.fixed_position

func set_speed(new_speed:float=default_speed):
	speed=new_speed
	speed_fixed=speed*fixed_point_factor
	

func set_friction(new_friction:float=default_friction):
	friction=new_friction
	friction_fixed = friction*fixed_point_factor

func set_mass(new_mass:float=default_mass):
	mass=new_mass
	mass_fixed=mass*fixed_point_factor

func reset_stats():
	anchor()
	set_friction()
	set_mass()
	set_speed()


func _physics_process(delta):
	#print("Trying to move speed ")
	#print (velocity.to_float())
	pass
func update_pos():
	#print("Before",velocity.to_float())
	#print(velocity.length()," vs ", friction_fixed)
	if velocity.length()>friction_fixed:
		velocity.isub(velocity.normalized().mul(friction_fixed))
	else:
		velocity.from_float(Vector2.ZERO)
	#TEST
	#print("After",velocity.to_float())
	#velocity.from_float(Vector2.ONE*speed/fixed_point_factor)
	#TEST
	if body!=null:
		if (body is SGCharacterBody2D):
			body.velocity=velocity
			#print("Setting body vel to ",body.velocity.to_float())
			body.move_and_slide()
			velocity=body.velocity
		elif body is SGFixedNode2D:
			body.fixed_position.iadd(velocity)
		else:
			printerr("Can't update position of non SGPhysics body")
			pass
	if can_move==false:
		body.fixed_position= SGFixed.vector2(lerp(body.fixed_position_x,anchored_pos.x,0.5),lerp(body.fixed_position_y,anchored_pos.y,0.5))
		pass
