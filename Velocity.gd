extends Node
class_name Velocity

const fixed_point_factor = 65536
const diag_factor = 46341

var velocity:SGFixedVector2 = SGFixedVector2.new()
var facing:int
var fixed_zero =SGFixed.vector2(0,0)
#Currently implemented: Player
enum movement_styles {PLAYER,PROJECTILE,TANK,RESTRICTED,TURRET,PLAYER_INSTANT}
@export var movement_style:movement_styles
@export var change_rotation_with_facing:bool
@export var body:SGFixedNode2D
@export var stop_input_at_max_vel:bool
@export var max_input_vel:float
@export var fixed_diagonal_velocity_difference:int
@export var fixed_angle_diff:int
const fixed_zero_range:int = 32
var max_input_vel_fixed_squared:int

@export_category("Player Style Movement")
@export_range(0,5) var speed:float
var speed_fixed:int
var default_speed:float
@export_range(0,1) var friction:float
var friction_fixed:int
var default_friction:float
@export var mass:float = 1
var mass_fixed:int
var default_mass:float
var can_move:bool=true

@export_category("Tank Style Movement")
@export_category("Fixed Point: multiply by 65536")
@export var turning_speed:float
var turning_speed_fixed:int
var default_turning_speed:float
@export var acceleration:float
var acceleration_fixed:int
var default_acceleration:float
@export var cut_accel:float
var cut_accel_fixed:int
var default_cut_accel:float
@export var max_speed:float
var max_speed_fixed:int
var default_max_speed:float
@export var friction_force_fixed:int

var anchored_pos:SGFixedVector2

func _ready():
	velocity.from_float(Vector2.ZERO)
	#TODO: All of this needs to go, no float multiplication
	speed_fixed=speed*fixed_point_factor
	friction_fixed=friction*fixed_point_factor
	mass_fixed=mass*fixed_point_factor
	default_speed=speed
	default_friction=friction
	default_mass=mass
	default_turning_speed=turning_speed
	turning_speed_fixed=turning_speed*fixed_point_factor
	default_acceleration=acceleration
	acceleration_fixed=acceleration*fixed_point_factor
	default_cut_accel=acceleration
	cut_accel_fixed=cut_accel*fixed_point_factor
	default_max_speed=max_speed
	max_speed_fixed=max_speed*fixed_point_factor
	
	
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
	#if movement_style == movement_styles.PLAYER:
		#player_move_input(direction)
	if movement_style == movement_styles.TANK:
		tank_move_input(direction)
	if movement_style == movement_styles.PLAYER_INSTANT:
		player_fixed_move_input(direction)

#func player_move_input(direction:SGFixedVector2):
	#if not direction.is_equal_approx(fixed_zero):
		#facing = direction.angle()
	#if can_move and direction!=null:
		#var add_to_vel = direction
		#add_to_vel.imul(speed_fixed/mass_fixed*fixed_point_factor)
		#if !stop_input_at_max_vel:
			#velocity.iadd(add_to_vel)
		#elif stop_input_at_max_vel and velocity.length_squared()<max_input_vel_fixed_squared:
			#velocity.iadd(add_to_vel)
	#else:
		#pass
	#velocity.imul(fixed_point_factor-friction_fixed)
	
func tank_move_input(direction:SGFixedVector2):
	facing += direction.x*turning_speed_fixed/fixed_point_factor
	if can_move:
		speed_fixed-=direction.y*acceleration
		if speed_fixed < 0:
			speed_fixed=0
		if speed_fixed > max_input_vel*fixed_point_factor:
			speed_fixed=max_input_vel*fixed_point_factor
		#var add_to_vel = SGFixed.vector2(speed_fixed,0).rotated(facing)
		var add_to_vel = MathHelper.get_unit_at_angle(facing).mul(speed_fixed)
		velocity.iadd(add_to_vel)
	speed_fixed*=(1-friction)

func player_instant_move_input(direction:SGFixedVector2):
	if not direction.is_equal_approx(fixed_zero):
		facing = direction.angle()
	else:
		velocity.imul(fixed_point_factor-friction_fixed)
	if can_move and direction!=null:
		velocity = direction.mul(speed_fixed/mass_fixed*fixed_point_factor)

func player_fixed_move_input(direction:SGFixedVector2):
	var is_diagonal = determine_diagonal_velocity()
	if not direction.is_equal_approx(fixed_zero):
		facing = direction.angle()
		if can_move:
			var max_speed_to_use = max_speed_fixed
			if is_diagonal:
				print("diagonal")
				max_speed_to_use = SGFixed.mul(max_speed_fixed,diag_factor)
			if direction.x!=0:
				if abs(velocity.x + SGFixed.mul(acceleration_fixed,direction.x)) < max_speed_to_use:
					velocity.x+=SGFixed.mul(acceleration_fixed,direction.x)
					#If changing direction, apply extra velocity
					if sign(velocity.x) != sign(direction.x) :
						print("cut")
						velocity.x+=SGFixed.mul(cut_accel_fixed,direction.x)
				else:
					velocity.x=sign(velocity.x)*max_speed_to_use
			if direction.y!=0:
				if abs(velocity.y + SGFixed.mul(acceleration_fixed,direction.y)) < max_speed_to_use:
					velocity.y+=SGFixed.mul(acceleration_fixed,direction.y)
					#If changing direction, apply extra velocity
					if sign(velocity.y) != sign(direction.y) :
						print("cut")
						velocity.y+=SGFixed.mul(cut_accel_fixed,direction.y)
				else:
					velocity.y=sign(velocity.y)*max_speed_to_use
	if direction.x == 0:
		#APPLY HORIZONTAL FRICTION
		if abs(velocity.x) < friction_force_fixed:
			velocity.x=0
		else:
			velocity.x = sign(velocity.x)*abs(abs(velocity.x)-friction_force_fixed)
	if direction.y == 0:
		#APPLY VERTICAL FRICTION
		if abs(velocity.y) < friction_force_fixed:
			velocity.y=0
		else:
			velocity.y = sign(velocity.y)*abs(abs(velocity.y)-friction_force_fixed)

#Doesn't work as well
func player_fixed_move_redo(direction:SGFixedVector2):
	#var is_diagonal = determine_diagonal_velocity()
	
	
	if not direction.is_equal_approx(fixed_zero):
		facing = direction.angle()
		if can_move:
			velocity.iadd(direction.mul(acceleration_fixed))
			var vel_norm = MathHelper.get_unit_at_angle(velocity.angle())
			var max_speed_rotated = vel_norm.mul(max_speed_fixed)
			if abs(velocity.x)> abs(max_speed_rotated.x):
				velocity.x=max_speed_rotated.x
			if abs(velocity.y) > abs(max_speed_rotated.y):
				velocity.y=max_speed_rotated.y
			if sign(velocity.x) != sign(direction.x) :
				print("cut")
				velocity.x+=SGFixed.mul(cut_accel_fixed,direction.x)
			if sign(velocity.y) != sign(direction.y) :
				print("cut")
				velocity.y+=SGFixed.mul(cut_accel_fixed,direction.y)
	if direction.x == 0:
		#APPLY HORIZONTAL FRICTION
		if abs(velocity.x) < friction_force_fixed:
			velocity.x=0
		else:
			velocity.x = sign(velocity.x)*abs(abs(velocity.x)-friction_force_fixed)
	if direction.y == 0:
		#APPLY VERTICAL FRICTION
		if abs(velocity.y) < friction_force_fixed:
			velocity.y=0
		else:
			velocity.y = sign(velocity.y)*abs(abs(velocity.y)-friction_force_fixed)

func determine_diagonal_velocity() ->bool:		
	if abs(abs(velocity.x) - abs(velocity.y)) < fixed_diagonal_velocity_difference:
		return true
	#var vel_angle = velocity.angle()
	#if vel_angle > MathHelper.a_180:
		#vel_angle -=MathHelper.a_180
	#if vel_angle > MathHelper.a_90:
		#vel_angle -=MathHelper.a_90
	#if abs(vel_angle-MathHelper.a_45)<fixed_angle_diff:
		#return true 
	else:
		return false
	
func constant_vel(angle:int):
	friction=0
	friction_fixed=friction*fixed_point_factor
	#velocity = SGFixed.vector2(fixed_point_factor,0).rotated(angle).mul(speed_fixed)
	velocity = MathHelper.get_unit_at_angle(angle).mul(speed_fixed)

func anchor(set_anchor:bool=false):
	can_move=!set_anchor
	velocity.from_float(Vector2.ZERO)
	anchored_pos=body.fixed_position

func set_speed(speed_factor:float=1.00):
	speed=default_speed*speed_factor
	speed_fixed=speed*fixed_point_factor
	

func set_friction(friction_factor:float=1.00):
	friction=default_friction*friction_factor
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
	if change_rotation_with_facing:
		body.fixed_rotation = facing

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
