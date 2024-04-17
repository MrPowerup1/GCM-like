extends Spell_Effect
class_name  Animation_Effect
#TEMPORARY VERSION UNTIL I FIGURE OUT ANIMATION
@export var new_player_sprite:Texture2D
# Called when the node enters the scene tree for the first time.

func trigger(target,caster:Player, spellindex:int):
	caster.set_sprite(new_player_sprite)
"res://Art/wizard.png"
