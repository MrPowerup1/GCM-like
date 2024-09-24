extends Resource
class_name Deck

@export var cards: Array[Card]
@export var allowed: Array[bool]

func random() -> Card:
	var index = randi_range(0,cards.size()-2)
	return cards[index]

func get_card(index:int) -> Card:
	return cards[index]

func get_index(card:Card) -> int:
	return cards.find(card)

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
		print ("Found and unselected")
		allowed[index] = true
		return true
	print("Couldn't find to unselect")
	return false

func subdeck(indices:Array) -> Deck:
	var new_deck = Deck.new()
	for index in indices:
		new_deck.cards.append(cards[index])
		new_deck.allowed.append(allowed[index]) 
	return new_deck
		
func reset():
	for i in range(allowed.size()):
		allowed[i] = true
