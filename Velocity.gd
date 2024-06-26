extends Node
class_name Velocity

const fixed_point_factor = 65536

var velocity:SGFixedVector2 = SGFixedVector2.new()
var facing:int
var fixed_zero =SGFixed.vector2(0,0)
@export var body:SGFixedNode2D
@export var stop_input_at_max_vel:bool
@export var max_input_vel:float
const fixed_zero_range:int = 32
var max_input_vel_fixed_squared:int

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
	max_input_vel_fixed_squared=max_input_vel*max_input_vel*fixed_point_factor
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
		print("starting position: ",body.fixed_position.to_float())
		print("Fixed Vector Pulse to ",direction.to_float())
		pulse_dir=direction.copy().sub(body.fixed_position).normalized()
	else:
		printerr("Cannot pulse to direction of type ",direction.name)
	var fixed_strength:int = strength*fixed_point_factor
	#print("Pre pulse",velocity.to_float())
	velocity.iadd(pulse_dir.mul(fixed_strength*fixed_point_factor/mass_fixed))
	#print("Post pulse",velocity.to_float())
func pulse_from(direction,strength: float):
	#print("Pulsing from", direction)
	#print("With strength",strength)
	var pulse_dir = SGFixedVector2.new()
	if (direction is Vector2):
		pulse_dir.from_float((direction-body.position).normalized())
	elif (direction is float):
		pulse_dir.from_float(Vector2.from_angle(direction))
	elif (direction is Node2D):
		pulse_dir.from_float((direction.position-body.position).normalized())
	elif (direction is SGFixedVector2):
		#print("Fixed Vector Pulse from ",direction.to_float())
		pulse_dir=direction.copy().sub(body.fixed_position).normalized()
	else:
		printerr("Cannot pulse from direction of type ",direction.name)
	var fixed_strength:int = strength*fixed_point_factor
	#print("Pre pulse",velocity.to_float())
	velocity.isub(pulse_dir.mul(fixed_strength*fixed_point_factor/mass_fixed))
	#print("Post pulse",velocity.to_float())

func move_input(direction:SGFixedVector2):
	if not direction.is_equal_approx(fixed_zero):
		facing = direction.angle()
	if can_move and direction!=null:
		var add_to_vel = direction
		print(speed)
		print(speed_fixed)
		add_to_vel.imul(speed_fixed/mass_fixed*fixed_point_factor)
		if !stop_input_at_max_vel:
			velocity.iadd(add_to_vel)
		elif stop_input_at_max_vel and velocity.length_squared()<max_input_vel_fixed_squared:
			velocity.iadd(add_to_vel)
	else:
		pass

func constant_vel(angle:int):
	friction=0
	friction_fixed=friction*fixed_point_factor
	velocity = SGFixed.vector2(fixed_point_factor,0).rotated(angle).mul(speed_fixed)

func anchor(set_anchor:bool=false):
	can_move=!set_anchor
	velocity.from_float(Vector2.ZERO)
	anchored_pos=body.fixed_position

func set_speed(new_speed:float=default_speed):
	print("New speed is ",new_speed)
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
	pass
func update_pos():
	# Velocity*= (1-friction)
	velocity.imul(fixed_point_factor-friction_fixed)
	# Set velocity to 0 if its close
	if abs(velocity.x)<fixed_zero_range:
		velocity.x=0
	if abs(velocity.y)<fixed_zero_range:
		velocity.y=0
	if body!=null:
		if (body is SGCharacterBody2D):
			body.velocity=velocity
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

func _save_state() ->Dictionary:
	return {
		velocity_x=velocity.x,
		velocity_y=velocity.y,
		facing=facing,
		can_move=can_move,
		friction = friction_fixed,
		speed = speed_fixed
	}
func _load_state(state:Dictionary) ->void:
	velocity.x=state['velocity_x']
	velocity.y=state['velocity_y']
	facing=state['facing']
	can_move=state['can_move']
	friction_fixed=state['friction']
	speed_fixed=state['speed']
