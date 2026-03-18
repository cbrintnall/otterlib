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
