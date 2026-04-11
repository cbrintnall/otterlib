extends Node
class_name Utils

static func flatten_array(array: Array) -> Array:
  return array.reduce(func(accum, next): accum.append_array(next); return accum, [])

static func averaged_random(rolls := 4) -> float:
  var sum := 0.0
  for i in rolls:
    sum += randf()
  return sum / rolls
  
# works for vec2 or vec3, courtesy of this post: https://www.reddit.com/r/godot/comments/mqp29g/how_do_i_get_a_random_position_inside_a_collision/
static func random_point_in_triangle(a, b, c):
  return a + sqrt(randf()) * (-a + b + randf() * (c - b))

static func area_of_triangle(a,b,c):
  var ba = a - b
  var bc = c - b 
  
  return ba.cross(bc).length()/2.0

static func random_unit_circle() -> Vector2:
  return Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))

static func get_key_pressed(event: InputEvent) -> Key:
  if event is InputEventKey and event.is_pressed():
    return event.keycode
  return KEY_NONE
  
static func with_alpha(clr: Color, alpha: float)-> Color:
  var next = clr
  next.a = alpha
  return next

static func random_color(alpha := 1) -> Color:
  return Color.from_hsv(randf(), randf(), randf(), alpha)

static func random_inside_rect(rect: Rect2) -> Vector2:
  return Vector2(randf_range(rect.position.x, rect.end.x), randf_range(rect.position.y, rect.end.y))

static func quadratic_bezier(a, b, c, t):
  var q0 = lerp(a, b, t)
  var q1 = lerp(b, c, t)
  return lerp(q0, q1, t)
  
static func arc_lerp(a, b, t, h := 1.0):
  var pos = a.lerp(b, t)
  
  pos.y -= sin(t*PI)*h
  
  return pos
  
static func name_to_id(n: String) -> String:
  return n.to_lower().replace(" ", "_")

static func debounce(timer: BetterTimer, cb: Callable):
  if timer.check(Engine.get_main_loop().root.get_process_delta_time(), false):
    cb.call()
    timer.reset()
