@tool
extends Resource
class_name ValueScalarDef

enum Scaling {
  RAW,
  LINEAR,
  EXPO,
  EXPO_OFFSET
}

@export var value := 10.0
@export var scaling := Scaling.LINEAR

func get_value(input: float) -> float:
  # Increase by one since we want the NEXT price
  var used_scalar = input + 1.0
  match scaling:
    Scaling.LINEAR:
      return maxf(value*used_scalar,value)
    Scaling.EXPO:
      return pow(value, used_scalar)
    Scaling.RAW:
      return value
    Scaling.EXPO_OFFSET:
      return pow(value+used_scalar, 2.0)
  return value
