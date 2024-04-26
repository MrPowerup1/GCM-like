extends Resource
class_name Deck

@export var cards: Array[Card]
@export var allowed: Array[bool]

func random() -> Card:
	var index = randi_range(0,cards.size()-2)
	return cards[index]

func start_cards() -> Array:
	return next_cards(cards[0])

func next_cards(new_center_card:Card) -> Array:
	var new_center_index = cards.find(new_center_card)
	var left_card = cards[(new_center_index-1)%cards.size()]
	var right_card = cards[(new_center_index+1)%cards.size()]
	var center_status = allowed[new_center_index]
	return [center_status,left_card,new_center_card,right_card]
	
func select(card:Card) -> bool:
	var index = cards.find(card)
	if allowed[index]:
		allowed[index] = false
		return true
	return false

func unselect(card:Card) -> bool:
	var index = cards.find(card)
	if !allowed[index]:
		allowed[index] = true
		return true
	return false
