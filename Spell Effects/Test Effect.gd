extends Threshold_Effect
class_name Test_Effect

@export var name:String

func trigger(caster:Player,spell_index:int,progress:float=0.0):
	#print ("Effect ",name," at index ", spell_index," is at progress ",progress)
