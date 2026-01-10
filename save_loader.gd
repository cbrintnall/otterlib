### A node that will load a save with a given save name, best put early in a tree since 
### load happens in the _ready() function.
extends Node
class_name SaveLoader

@export var save_name: String = "game.save"

func _ready() -> void:
  SaveManager.save_name = save_name
  SaveManager.load_save()
