extends Card
class_name SpellCard

@export var spell:Spell
@export var element:Element
@export var requirements:Array[Element] = []
#Should be bitflags
enum Categories {None,Melee,Mobility}
#var category
@export var category:Categories
#@export_enum("Buff","Movement","Attack","Defense") var type:int
@export var randomizer = false

#@export var context:CardContext

func select(player_index:int,context:CardContext,spell_slot_index:int=-1):
	var universal_spell_slot:int = GameManager.universal_spell_deck.get_index(self)
	if context == CardContext.SELECTING:
		if spell_slot_index ==-1:
			spell_slot_index = GameManager.players[player_index]['selected_spells'].find(-1)
		GameManager.players[player_index]['selected_spells'][spell_slot_index]= universal_spell_slot
	elif context == CardContext.LEARNING:
		GameManager.players[player_index]['known_spells'].append(universal_spell_slot)
		GameManager.update_spell_deck(player_index)

func unselect(player_index:int,context:CardContext):  #,spell_slot_index:int=-1):
	var universal_spell_slot:int = GameManager.universal_spell_deck.get_index(self)
	if context == CardContext.SELECTING:
		##IF SPELL SLOT NOT GIVEN
		#if spell_slot_index ==-1:
			##CHECK FOR UNSELECTED SPELL SLOT
			#if GameManager.players[player_index]['selected_spells'].has(-1):
				#spell_slot_index = GameManager.players[player_index]['selected_spells'].find(-1) -1
			##IF ALL SELECTED, PICK LAST
			#else:
				#spell_slot_index =GameManager.players[player_index]['selected_spells'].last()
		#GameManager.players[player_index]['selected_spells'][spell_slot_index]= universal_spell_slot
		var index = GameManager.players[player_index]['selected_spells'].find(universal_spell_slot)
		GameManager.players[player_index]['selected_spells'][index] = -1
	elif context == CardContext.LEARNING:
		GameManager.players[player_index]['known_spells'].erase(universal_spell_slot)
	

func display(card:CardDisplay):
	card.set_cardname(name)
	card.set_description(description)
	card.set_image(image)
	#Sets panel to default type
	#card.set_theme_type("SpellPanel")
