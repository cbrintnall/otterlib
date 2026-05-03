@tool
extends Resource
class_name StatDef

@export_category("metadata")
## how this is display to user
@export var name: String
@export_multiline var description := ""
@export_enum("raw", "integer", "percent", "multiplier", "rate_seconds") var format_style := "integer"
@export_category("values")
## The absolute max this can return
@export var max_value := INF
## The starting value, also used for value calculations (see notion)
@export var base_value := 1.0

func get_description(current: float):
  return description.format({ "current": StatProviderDef.get_value_as_format(current, format_style) })
