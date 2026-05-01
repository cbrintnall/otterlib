extends Resource
class_name StatProviderDef

enum ContributionType {
  ADDITIVE,
  MULTIPLICATIVE,
  SET
}

static func from(amount: float, contribution := ContributionType.ADDITIVE) -> StatProviderDef:
  var def := StatProviderDef.new()
  
  def.amount = amount
  def.contribution_type = contribution
  
  return def
  
static func get_value_as_format(amount: float, format := "integer") -> String:
  var used_format = format

  match used_format:
    "integer":
      return "%+d" % roundi(amount)
    "percent":
      return "%+.0f%%" % (amount*100.0)
    "multiplier":
      return "%.1fx" % amount
    "rate_seconds":
      return "%.1f/s" % amount
  return str(amount)

## how much is this provider worth?
@export var amount := 1.0
## how does this contribute to the stat?
@export var contribution_type := ContributionType.ADDITIVE
@export_category("metadata")
@export_multiline var description := "Increases {stat} by {amount}."
@export_enum("raw", "integer", "percent", "multiplier", "rate_seconds") var format_style := "integer"

func get_current_as_format(override := "") -> String:
  if override:
    return StatProviderDef.get_value_as_format(amount, override)
  return StatProviderDef.get_value_as_format(amount, format_style)
