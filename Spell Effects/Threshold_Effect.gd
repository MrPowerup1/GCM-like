extends Spell_Effect
class_name Threshold_Effect

@export var threshold_values:Array[float]=[]
@export var effects:Array[Spell_Effect]=[]

#base trigger
func trigger (caster:Player,spell_index:int,progress:float=0.0):
	#can't even meet base threshold (e.g min threshold is 0.1, and progress is 0%)
	if (progress<=threshold_values[0]):
		#effects[0].trigger(caster)
		pass
	else:
		for i in range(threshold_values.size()):
			if threshold_values[i]>=progress:
				effects[i-1].trigger(caster,spell_index)
				return
		effects[threshold_values.size()-1].trigger(caster,spell_index)

