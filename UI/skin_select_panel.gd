extends PanelContainer
class_name SkinSelectPanel

@export var skins:SkinDeck
@export var left_skin:CharacterSkin
@export var center_skin:CharacterSkin
@export var right_skin:CharacterSkin

enum display_mode {SELECTED,SELECTING}
var current_mode:display_mode

func _ready():
	#Ensure that the materials and shaders are unique copies (don't share color)
	%LeftSkin.image_ref.material = %CenterSkin.image_ref.material.duplicate(true)
	%RightSkin.image_ref.material = %CenterSkin.image_ref.material.duplicate(true)
	%CenterSkin.image_ref.material = %CenterSkin.image_ref.material.duplicate(true)
	#Get the default skins and display them
	var to_display = skins.start_skins()
	new_skins(to_display)
	

signal exit()
signal next()

func left():
	new_skins(skins.next_skins(left_skin))
	print("Go Left")
func right():
	new_skins(skins.next_skins(right_skin))
	print ("Go RIght")
func up():
	pass
func down():
	pass
func select():
	if true:
		if center_skin.randomizer:
			new_skins(skins.next_skins(skins.random()))
			print ("Selecting")
			skins.select(center_skin)
			new_skins(skins.next_skins(center_skin))
			next.emit()
		else:
			print ("Selecting")
			skins.select(center_skin)
			new_skins(skins.next_skins(center_skin))
			next.emit()
func back():
	exit.emit()

func unselect_skin():
	skins.unselect(center_skin)
	new_skins(skins.next_skins(center_skin))
	
func new_skins(to_display:Array):
	if to_display[0]==false:
		pass
		%SelectButton.text="Selected"
		%SelectButton.disabled=true
	else:
		pass
		%SelectButton.text="Select"
		%SelectButton.disabled=false
	left_skin=to_display[1]
	%LeftSkin.set_new_skin(left_skin)
	center_skin=to_display[2]
	%CenterSkin.set_new_skin(center_skin)
	right_skin=to_display[3]
	%RightSkin.set_new_skin(right_skin)

func transition_display_mode(new_mode:display_mode):
	if new_mode==display_mode.SELECTED:
		%LeftButton.visible=false
		%LeftSkin.visible=false
		%SelectButton.visible=false
		%RightButton.visible=false
		%RightSkin.visible=false
	if new_mode==display_mode.SELECTING:
		%LeftButton.visible=true
		%LeftSkin.visible=true
		%SelectButton.visible=true
		%RightButton.visible=true
		%RightSkin.visible=true
	current_mode=new_mode
