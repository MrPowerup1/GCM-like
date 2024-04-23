extends PanelContainer
class_name SpellSelectPanel

@export var spells:SpellDeck
@export var left_spell:Spell_Type
@export var center_spell:Spell_Type
@export var right_spell:Spell_Type
enum display_mode {SELECTED,SELECTING}
var current_mode:display_mode



func _ready():
	#Get the default skins and display them
	print(spells)
	var to_display = spells.start_spells()
	new_spells(to_display)
	

signal exit()
signal next()

func left():
	new_spells(spells.next_spells(left_spell))
	print("Go Left")
func right():
	new_spells(spells.next_spells(right_spell))
	print ("Go Right")
func up():
	pass
func down():
	pass
func select():
	if true:
		if center_spell.randomizer:
			new_spells(spells.next_spells(spells.random()))
			print ("Selecting")
			spells.select(center_spell)
			new_spells(spells.next_spells(center_spell))
			next.emit()
		else:
			print ("Selecting")
			spells.select(center_spell)
			new_spells(spells.next_spells(center_spell))
			next.emit()
func back():
	exit.emit()

func unselect_spell():
	spells.unselect(center_spell)
	new_spells(spells.next_spells(center_spell))
	
func new_spells(to_display:Array):
	if to_display[0]==false:
		pass
		%SelectButton.text="Selected"
		%SelectButton.disabled=true
	else:
		pass
		%SelectButton.text="Select"
		%SelectButton.disabled=false
	left_spell=to_display[1]
	%LeftSpell.set_new_spell(left_spell)
	center_spell=to_display[2]
	%CenterSpell.set_new_spell(center_spell)
	right_spell=to_display[3]
	%RightSpell.set_new_spell(right_spell)

func transition_display_mode(new_mode:display_mode):
	if new_mode==display_mode.SELECTED:
		%LeftButton.visible=false
		%LeftSpell.visible=false
		%SelectButton.visible=false
		%RightButton.visible=false
		%RightSpell.visible=false
	if new_mode==display_mode.SELECTING:
		%LeftButton.visible=true
		%LeftSpell.visible=true
		%SelectButton.visible=true
		%RightButton.visible=true
		%RightSpell.visible=true
	current_mode=new_mode
