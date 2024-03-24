extends Node
class_name Base_Spell

var description:String
var card_image:Texture2D
var element:Element
var requirements:Array[Element] = []
var category:int
var type:int


func initialize(spell : Spell):
	saveBaseSpellStats(spell)
	
func saveBaseSpellStats(spell:Spell):
	name=spell.name
	description=spell.description
	card_image=spell.card_image
	element=spell.element
	requirements=spell.requirements
	category=spell.category
	type=spell.type

# Called when the node enters the scene tree for the first time.
func activate(caster:Player):
	pass
