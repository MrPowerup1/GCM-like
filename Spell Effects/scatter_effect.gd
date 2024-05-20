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
@export var min_offset_position:Vector2
@export var max_offset_position:Vector2
var min_offset_fixed:SGFixedVector2 = SGFixedVector2.new()
var max_offset_fixed:SGFixedVector2 = SGFixedVector2.new()

# Called when the node enters the scene tree for the first time.
func trigger(target,caster:Player,spell_index:int,position:SGFixedVector2=target.fixed_position):
	#HACK: will this cause issues with modifying saved resources for spawning?
	#Run once, setup offsets:
	min_offset_fixed.from_float(min_offset_position)
	max_offset_fixed.from_float(max_offset_position)
	var positions = []
	if type==scatter_type.arc:
		positions=positions_in_arc(position)
	elif type==scatter_type.line:
		positions=positions_in_line(position)
	elif type==scatter_type.grid:
		positions=positions_in_grid(position)
	for new_position in positions:
		effect.trigger(target,caster,spell_index,new_position)
	
func positions_in_arc(root:SGFixedVector2) ->Array[SGFixedVector2]:
	var positions:Array[SGFixedVector2] = []
	var angle_between = (max_angle-min_angle)/count
	for i in range(count):
		positions.append(root.add(SGFixed.vector2(65536,0).rotated(min_angle+i*angle_between).mul(radius)))
	return positions

func positions_in_line(root:SGFixedVector2) ->Array[SGFixedVector2]:
	var positions:Array[SGFixedVector2] = []
	var offset_between = (max_offset_position-min_offset_position)/count
	for i in range(count):
		positions.append(root.add(min_offset_fixed).add(offset_between.mul(i)))
	return positions

func positions_in_grid(root:SGFixedVector2) ->Array[SGFixedVector2]:
	var countsqrt = floor(sqrt(count))
	var positions:Array[SGFixedVector2] = []
	var x_offset_between = (max_offset_fixed.x-min_offset_fixed.x)/countsqrt
	var y_offset_between = (max_offset_fixed.y-min_offset_fixed.y)/countsqrt
	var j = 0
	for i in range(count):
		if i+1>(countsqrt + j*countsqrt):
			j+=1
		positions.append(root.add(min_offset_fixed).add(SGFixed.vector2((i+1)*x_offset_between-j*countsqrt*x_offset_between,j*y_offset_between)))
	return positions
