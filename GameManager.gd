extends Node

#TODO: Network peers, not players
var players = {}

var alive_players:Array[PlayerManager] =[]

#Sync the skin deck selection for all players
var skin_deck:Deck

#Just used to ensure one time activations
var is_host:bool = false

