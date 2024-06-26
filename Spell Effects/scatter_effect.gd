extends Positional_Effect
class_name Scatter_Effect

enum scatter_type {line,arc,grid}
@export var effect:Positional_Effect
@export var type:scatter_type
@export var count:int
@export_category("Arc Type")
@export var min_angle:float
@export var max_angle:float
@export var radius:float
@export_category("Line/Grid Type")
var min_offset_position:Vector2
var max_offset_position:Vector2
@export var min_offset_x:int
@export var min_offset_y:int
@export var max_offset_x:int
@export var max_offset_y:int
const fixed_factor:int = 65536
var min_offset_fixed:SGFixedVector2 = SGFixedVector2.new()
var max_offset_fixed:SGFixedVector2 = SGFixedVector2.new()

# Called when the node enters the scene tree for the first time.
func trigger(target,caster:Player,spell_index:int,position:SGFixedVector2=target.fixed_position):
	
	var angle = target.get_facing()
	var positions = []
	if type==scatter_type.arc:
		positions=positions_in_arc(position,angle)
	elif type==scatter_type.line:
		positions=positions_in_line(position,angle)
	elif type==scatter_type.grid:
		positions=positions_in_grid(position,angle)
	print(positions)
	for new_position in positions:
		print(new_position.to_float())
		effect.trigger(target,caster,spell_index,new_position)
	
func positions_in_arc(root:SGFixedVector2,angle:int) ->Array[SGFixedVector2]:
	var positions:Array[SGFixedVector2] = []
	var angle_between = deg_to_rad((max_angle-min_angle)/count*fixed_factor)
	for i in range(count):
		var rot_angle = (-angle+fixed_factor*deg_to_rad(min_angle)+i*angle_between)
		var ray = SGFixed.vector2(int(fixed_factor*radius),0).rotated(rot_angle)
		print("Angle rotated is ",rot_angle)
		print("Change is ",ray.to_float())
		var to_append = root.add(ray)
		print("Root is ",root.to_float())
		print("New arc pos is ",to_append.to_float())
		positions.append(to_append)
	return positions

func positions_in_line(root:SGFixedVector2,angle:int) ->Array[SGFixedVector2]:
	var positions:Array[SGFixedVector2] = []
	var offset_between = SGFixed.vector2((max_offset_x-min_offset_x)/count*fixed_factor,(max_offset_y-min_offset_y)/count*fixed_factor)
	print(offset_between.to_float())
	for i in range(count):
		positions.append(root.add(SGFixed.vector2(min_offset_x*fixed_factor,min_offset_y*fixed_factor).add(offset_between.mul(i*fixed_factor))))
	return positions

func positions_in_grid(root:SGFixedVector2,angle:int) ->Array[SGFixedVector2]:
	var countsqrt = floor(sqrt(count))
	var positions:Array[SGFixedVector2] = []
	var x_offset_between = (max_offset_x-min_offset_x)/countsqrt
	var y_offset_between = (max_offset_y-min_offset_y)/countsqrt
	var j = 0
	for i in range(count):
		if i+1>(countsqrt + j*countsqrt):
			j+=1
		positions.append(root.add(SGFixed.vector2(min_offset_x*fixed_factor,min_offset_y*fixed_factor)).add(SGFixed.vector2(((i+1)*x_offset_between-j*countsqrt*x_offset_between)*fixed_factor,j*y_offset_between*fixed_factor)))
	return positions
