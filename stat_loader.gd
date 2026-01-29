extends Node
class_name StatLoader

@export var store: StatStore
@export var stat: StatDef
@export var providers: Array[StatProviderDef]

func _ready() -> void:
  for provider in providers:
    store.add_provider(stat, provider)

  queue_free()
