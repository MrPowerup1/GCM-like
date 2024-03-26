class_name Spell
extends Resource

@export var name:String
@export var card_image:Texture2D
@export_multiline var description:String
@export var element:Element
@export var requirements:Array[Element] = []
@export_enum("Passive","Active") var category:int
@export_enum("Buff","Movement","Attack","Defense") var type:int
@export var spell_scene:PackedScene
