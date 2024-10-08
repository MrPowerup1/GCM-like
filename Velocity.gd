extends Node
class_name Velocity

const fixed_point_factor = 65536
const diag_factor = 46341

var velocity:SGFixedVector2 = SGFixedVector2.new()
var facing:int
var fixed_zero =SGFixed.vector2(0,0)
#Currently implemented: Player
enum movement_styles {PLAYER,PROJECTILE,TANK,RESTRICTED,TURRET,STEP,PATH}
@export var movement_style:movement_styles
@export var animate:bool
@export var animation_player:AnimationPlayer
@export var change_rotation_with_facing:bool
@export var body:SGFixedNode2D
#@export var stop_input_at_max_vel:bool
#@export var max_input_vel:float
@export var fixed_diagonal_velocity_difference:int
#Unused
@export var fixed_angle_diff:int
const fixed_zero_range:int = 32
#var max_input_vel_fixed_squared:int
var can_move:bool=true

@export_category("Player Style Movement")

@export var friction_fixed:int
var default_friction:int

@export var mass_fixed:int
var default_mass:int

@export var acceleration_fixed:int
var default_acceleration:int

@export var cut_accel_fixed:int
var default_cut_accel:int

@export var max_speed_fixed:int
var default_max_speed:int

@export_category("Tank Style Movement")

var speed_fixed:int

@export var turning_speed_fixed:int
var default_turning_speed:int

var anchored_pos:SGFixedVector2

func _ready():
	velocity.from_float(Vector2.ZERO)
	#TODO: All of this needs to go, no float multiplication
	default_friction=friction_fixed
	default_mass=mass_fixed
	default_turning_speed=turning_speed_fixed
	default_acceleration=acceleration_fixed
	default_cut_accel=cut_accel_fixed
	default_max_speed=max_speed_fixed
	#max_input_vel_fixed_squared=max_input_vel*max_input_vel*fixed_point_factor
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
	if movement_style == movement_styles.PLAYER:
		player_fixed_move_input(direction)
		if animate == true:
			animate_player_movement(direction)
	if movement_style == movement_styles.STEP:
		step_move(direction)

func animate_player_movement(direction:SGFixedVector2):
	if animation_player.current_animation!="Cast1" and animation_player.current_animation!="Idle" and direction.x==0 and direction.y == 0:
		animation_player.play("Idle")
	elif can_move and direction.x>0:
		%Sprite2D.flip_h = false
		animation_player.play("Walk")
	elif can_move and direction.x<0:
		animation_player.play("Walk")
		%Sprite2D.flip_h = true
	elif can_move and direction.y != 0:
		animation_player.play("Walk")
	
func tank_move_input(direction:SGFixedVector2):
	facing += direction.x*turning_speed_fixed/fixed_point_factor
	if can_move:
		speed_fixed-=direction.y*acceleration_fixed
		if speed_fixed < 0:
			speed_fixed=0
		if speed_fixed > max_speed_fixed:
			speed_fixed=max_speed_fixed
		#var add_to_vel = SGFixed.vector2(speed_fixed,0).rotated(facing)
		var add_to_vel = MathHelper.get_unit_at_angle(facing).mul(speed_fixed)
		velocity.iadd(add_to_vel)
	if direction.is_equal_approx(fixed_zero):
		speed_fixed-=sign(speed_fixed)*friction_fixed

func player_fixed_move_input(direction:SGFixedVector2):
	var is_diagonal = determine_diagonal_velocity()
	if not direction.is_equal_approx(fixed_zero):
		facing = direction.angle()
		if can_move:
			var max_speed_to_use = max_speed_fixed
			if is_diagonal:

				max_speed_to_use = SGFixed.mul(max_speed_fixed,diag_factor)
			if direction.x!=0:
				if abs(velocity.x + SGFixed.mul(acceleration_fixed,direction.x)) < max_speed_to_use:
					velocity.x+=SGFixed.mul(acceleration_fixed,direction.x)
					#If changing direction, apply extra velocity
					if sign(velocity.x) != sign(direction.x) :
						velocity.x+=SGFixed.mul(cut_accel_fixed,direction.x)
				else:
					velocity.x=sign(velocity.x)*max_speed_to_use
			if direction.y!=0:
				if abs(velocity.y + SGFixed.mul(acceleration_fixed,direction.y)) < max_speed_to_use:
					velocity.y+=SGFixed.mul(acceleration_fixed,direction.y)
					#If changing direction, apply extra velocity
					if sign(velocity.y) != sign(direction.y) :
						velocity.y+=SGFixed.mul(cut_accel_fixed,direction.y)
				else:
					velocity.y=sign(velocity.y)*max_speed_to_use
	if  direction.x == 0 or abs(velocity.x) > max_speed_fixed:
		#APPLY HORIZONTAL FRICTION
		if abs(velocity.x) < friction_fixed:
			velocity.x=0
		else:
			velocity.x = sign(velocity.x)*abs(abs(velocity.x)-friction_fixed)
	if  direction.y == 0 or abs(velocity.y) > max_speed_fixed:
		#APPLY VERTICAL FRICTION
		if abs(velocity.y) < friction_fixed:
			velocity.y=0
		else:
			velocity.y = sign(velocity.y)*abs(abs(velocity.y)-friction_fixed)
func step_move(direction:SGFixedVector2):
	velocity.x=direction.x*max_speed_fixed/fixed_point_factor
	velocity.y=direction.y*max_speed_fixed/fixed_point_factor
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
				velocity.x+=SGFixed.mul(cut_accel_fixed,direction.x)
			if sign(velocity.y) != sign(direction.y) :
				velocity.y+=SGFixed.mul(cut_accel_fixed,direction.y)
	if direction.x == 0 or abs(velocity.x) > friction_fixed:
		#APPLY HORIZONTAL FRICTION
		if abs(velocity.x) < friction_fixed:
			velocity.x=0
		else:
			velocity.x = sign(velocity.x)*abs(abs(velocity.x)-friction_fixed)
	if direction.y == 0:
		#APPLY VERTICAL FRICTION
		if abs(velocity.y) < friction_fixed:
			velocity.y=0
		else:
			velocity.y = sign(velocity.y)*abs(abs(velocity.y)-friction_fixed)

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
	velocity = SGFixed.vector2(fixed_point_factor,0).rotated(angle).mul(max_speed_fixed)
	#velocity = MathHelper.get_unit_at_angle(angle).mul(speed_fixed)

func anchor(set_anchor:bool=false):
	can_move=!set_anchor
	velocity.from_float(Vector2.ZERO)
	anchored_pos=body.fixed_position

func set_speed(speed_factor:int=65536):
	max_speed_fixed = SGFixed.mul(speed_factor,default_max_speed)
	acceleration_fixed =SGFixed.mul(speed_factor,default_acceleration)
	cut_accel_fixed =SGFixed.mul(speed_factor,default_cut_accel) 

func set_friction(friction_factor:int=65536):
	friction_fixed = SGFixed.mul(friction_factor,default_friction)

func set_mass(mass_factor:int=65536):
	mass_fixed = SGFixed.mul(mass_factor,default_mass)

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
		speed = speed_fixed,
		max_speed = max_speed_fixed,
		acceleration = acceleration_fixed,
		cut_accel = cut_accel_fixed
	}
func _load_state(state:Dictionary) ->void:
	velocity.x=state['velocity_x']
	velocity.y=state['velocity_y']
	facing=state['facing']
	can_move=state['can_move']
	friction_fixed=state['friction']
	speed_fixed=state['speed']
	max_speed_fixed = state['max_speed']
	acceleration_fixed =state['acceleration']
	cut_accel_fixed=state['cut_accel']
