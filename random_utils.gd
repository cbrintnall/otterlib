extends Node
class_name RandomUtils

static func random_color(alpha := 1.0) -> Color:
  return Color(randf(), randf(), randf(), alpha)

static func random_unit_circle() -> Vector2:
  return Vector2(
    randf_range(-1.0, 1.0),
    randf_range(-1.0, 1.0)
  )
