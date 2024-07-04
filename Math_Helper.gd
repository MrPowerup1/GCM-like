extends Node

const x_0 = 65536
const y_0 = 0
const a_0 = 0
const x_15 = 63303
const y_15 = 16962
const a_15 = 17157
const x_30 = 56756
const y_30 = 32768
const a_30 = 34315
const x_45 = 46341
const y_45 = 46341
const a_45 = 51472
const x_60 = 32768
const y_60 = 56756
const a_60 = 68629
const x_75 = 16962
const y_75 = 63303
const a_75 = 85786
const x_90 = 0
const y_90 = 65536
const a_90 = 102944
const a_180 = 205887
const a_360 = 411774

const deg_to_fixed_rad = 1144

var x_vals = [x_0,x_15,x_30,x_45,x_60,x_75,x_90]
var y_vals = [y_0,y_15,y_30,y_45,y_60,y_75,y_90]
var a_vals = [a_0,a_15,a_30,a_45,a_60,a_75,a_90]

func get_unit_at_angle(angle:int) ->SGFixedVector2:
	print ("Getting vector of angle ",angle)
	var x_sign = 1
	var y_sign = 1
	var flip = false
	if angle < 0:
		angle +=a_360
	if angle > a_180:
		#Negate X and Y
		x_sign *=-1
		y_sign *=-1
		angle -=a_180
		print ("Over 180, new angle is ",angle)
		
	if angle > a_90:
		#Negate X, Flip X and Y
		x_sign*=-1
		flip = !flip
		angle -=a_90
		print ("Over 90, new angle is ",angle)
		
	var index = find_closest_angle_index(angle)
	print ("Found closest angle is ",a_vals[index])
	if flip:
		return SGFixed.vector2(x_sign*y_vals[index],y_sign*x_vals[index])
	return SGFixed.vector2(x_sign*x_vals[index],y_sign*y_vals[index])

#Returns index of closest angle in list
func find_closest_angle_index(angle:int) ->int:
	for i in range(a_vals.size()):
		if a_vals[i] >= angle:
			if i == 0:
				return 0
			elif a_vals[i] - angle < angle - a_vals[i-1]:
				return i
			else:
				return i-1
	printerr ("Angle too large")
	return -1
