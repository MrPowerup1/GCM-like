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

# Called when the node enters the scene tree for the first time.
func trigger(target,caster:Player,spell_index:int,position:Vector2=target.position):
	var positions = []
	if type==scatter_type.arc:
		positions=positions_in_arc(position)
	elif type==scatter_type.line:
		positions=positions_in_line(position)
	elif type==scatter_type.grid:
		positions=positions_in_grid(position)
	for new_position in positions:
		effect.trigger(target,caster,spell_index,new_position)
	
func positions_in_arc(root:Vector2) ->Array[Vector2]:
	var positions:Array[Vector2] = []
	var angle_between = (max_angle-min_angle)/count
	for i in range(count):
		positions.append(root + radius * Vector2.RIGHT.rotated(min_angle+i*angle_between))
	return positions

func positions_in_line(root:Vector2) ->Array[Vector2]:
	var positions:Array[Vector2] = []
	var offset_between = (max_offset_position-min_offset_position)/count
	for i in range(count):
		positions.append(root + min_offset_position+i*offset_between)
	return positions

func positions_in_grid(root:Vector2) ->Array[Vector2]:
	var countsqrt = floor(sqrt(count))
	var positions:Array[Vector2] = []
	var x_offset_between = (max_offset_position.x-min_offset_position.x)/countsqrt
	var y_offset_between = (max_offset_position.y-min_offset_position.y)/countsqrt
	var j = 0
	for i in range(count):
		if i+1>(countsqrt + j*countsqrt):
			j+=1
		positions.append(root + min_offset_position+Vector2.RIGHT*((i+1)*x_offset_between-j*countsqrt*x_offset_between)+Vector2.DOWN*(j*y_offset_between))
	return positions
