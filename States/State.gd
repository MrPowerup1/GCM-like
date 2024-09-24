extends Node
class_name State


@export var do_process:bool = true
@export var do_physics_process:bool = true
@export var do_network_process:bool = true

signal Transition

func enter():
	pass

func exit():
	pass

func process(_delta:float):
	pass

func physics_process(_delta:float):
	pass

func network_process(input:Dictionary):
	pass
