extends Node
class_name StatStore

signal changed(stat: StatDef)

@export var stats : Array[StatDef]

var _store := {}
var _dirty_stats := []
var _values := {}

func _ready() -> void:
  for stat in stats:
    if not _store.has(stat):
      _store[stat] = []
  
func add_provider(stat: StatDef, provider: StatProviderDef):
  var providers = _store.get_or_add(stat, [])
  providers.push_back(provider)
  _dirty_stats.push_back(stat)

func get_value(stat: StatDef) -> float:
  if not _values.has(stat):
    _values[stat] = _calculate_stat(stat)
  
  return _values[stat]
  
func _process(_delta: float) -> void:
  while _dirty_stats:
    var next: StatDef = _dirty_stats.pop_front()
    _values[next] = _calculate_stat(next)
    changed.emit(next)

func _calculate_stat(stat: StatDef) -> float:
  var value := stat.base_value
  var additive := 0.0
  var multiplicative := 1.0
  
  for provider: StatProviderDef in _store.get(stat, []):
    match provider.contribution_type:
      StatProviderDef.ContributionType.ADDITIVE:
        additive += provider.amount
      StatProviderDef.ContributionType.MULTIPLICATIVE:
        multiplicative += provider.amount
  
  return minf((value+additive)*multiplicative, stat.max_value)
