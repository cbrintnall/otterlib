extends Resource
class_name StatProviderDef

enum ContributionType {
  ADDITIVE,
  MULTIPLICATIVE
}

## how much is this provider worth?
@export var amount := 1.0
## how does this contribute to the stat?
@export var contribution_type := ContributionType.ADDITIVE
@export_category("metadata")
@export_multiline var description := "Increases {stat} by {amount}."
@export_enum("raw", "integer", "percent", "multiplier") var format_style := "integer"

func get_value_as_format() -> String:
  match format_style:
    "integer":
      return str(roundi(amount))
    "percent":
      return "%.2f%%" % (amount*100.0)
    "multiplier":
      return "%.1fx" % amount
  return str(amount)
