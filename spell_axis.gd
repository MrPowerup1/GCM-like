extends MarginContainer
class_name SpellAxis

@export var top_spell:CardDisplayContainer
@export var left_spell:CardDisplayContainer
@export var right_spell:CardDisplayContainer
@export var bottom_spell:CardDisplayContainer
@export var top_icon:TextureRect
@export var left_icon:TextureRect
@export var bottom_icon:TextureRect
@export var right_icon:TextureRect
#var card_displays:Array[CardDisplay]
#
#func add_display(new_display:CardDisplay):
	#card_displays.append(new_display)

func set_display_style(new_style:CardDisplay.DisplayStyle):
	#for card_display in card_displays:
		#card_display.set_display_style(new_style)
	
	set_child_display_if_exists(top_spell,new_style)
	set_child_display_if_exists(bottom_spell,new_style)
	set_child_display_if_exists(left_spell,new_style)
	set_child_display_if_exists(right_spell,new_style)
	#%"Bottom Spell".get_child(0).set_display_style(new_style)
	#%"Left Spell".get_child(0).set_display_style(new_style)
	#%"Right Spell".get_child(0).set_display_style(new_style)

func set_child_display_if_exists(node,new_style:CardDisplay.DisplayStyle):
	if node.get_child_count() > 0:
		node.get_child(0).set_display_style(new_style)

func set_mode(new_mode:CardDisplay.Mode):
	#for card_display in card_displays:
		#card_display.set_mode(new_mode)
	set_child_mode_if_exists(top_spell,new_mode)
	set_child_mode_if_exists(bottom_spell,new_mode)
	set_child_mode_if_exists(left_spell,new_mode)
	set_child_mode_if_exists(right_spell,new_mode)
	#%"Top Spell".get_child(0).set_mode(new_mode)
	#%"Bottom Spell".get_child(0).set_mode(new_mode)
	#%"Left Spell".get_child(0).set_mode(new_mode)
	#%"Right Spell".get_child(0).set_mode(new_mode)
	
func set_child_mode_if_exists(node,new_mode:CardDisplay.Mode):
	if node.get_child_count() > 0:
		node.get_child(0).set_mode(new_mode)

func set_deck(new_deck:Deck):
	#ORDER IS IMPORTANT: left and bottom before others (melee and mobility restrictions apply first)
	left_spell.load_deck(new_deck)
	bottom_spell.load_deck(new_deck)
	
	top_spell.load_deck(new_deck)
	right_spell.load_deck(new_deck)
func set_player_index(new_player_index:int):
	top_spell.player_index = new_player_index
	right_spell.player_index = new_player_index
	left_spell.player_index = new_player_index
	bottom_spell.player_index = new_player_index
	

func unlearn(check_card:Card):
	top_spell.unlearn(check_card)
	left_spell.unlearn(check_card)
	right_spell.unlearn(check_card)
	bottom_spell.unlearn(check_card)

func load_spells(spell_index:Array):
	print("Top spell loading ",spell_index[0]," : ",GameManager.universal_spell_deck.get_card(spell_index[0]).name)
	print("Left spell loading ",spell_index[1]," : ",GameManager.universal_spell_deck.get_card(spell_index[1]).name)
	print("Right spell loading ",spell_index[2]," : ",GameManager.universal_spell_deck.get_card(spell_index[2]).name)
	print("Bottom spell loading ",spell_index[3]," : ",GameManager.universal_spell_deck.get_card(spell_index[3]).name)

func change_icons(input_scheme:Input_Keys):
	top_icon.texture = load(input_scheme.icons["Spell2"])
	right_icon.texture = load(input_scheme.icons["Spell1"])
	left_icon.texture = load(input_scheme.icons["Melee"])
	bottom_icon.texture = load(input_scheme.icons["Mobility"])
