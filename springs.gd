extends Node
class_name Springs

const MAX_DELTA = (1.0 / 60.0)

static func spring_accel(pos, target, velocity, stiffness: float, damping: float):
  var displacement = pos - target
  return (-stiffness * displacement) - (damping * velocity)

static func spring(pos, target, velocity, delta: float, stiffness: float, damping: float) -> Dictionary:
  var clamped_delta = minf(delta, MAX_DELTA)
  var displacement = pos - target
  var acceleration = (-stiffness * displacement) - (damping * velocity)
  var new_velocity = velocity + acceleration * clamped_delta
  var new_position = pos + new_velocity * clamped_delta

  return { "position": new_position, "velocity": new_velocity }

static func spring_angle(pos, target, velocity, delta: float, stiffness: float, damping: float) -> Dictionary:
  var clamped_delta = minf(delta, MAX_DELTA)
  var displacement = angle_difference(target, pos)
  var acceleration = (-stiffness * displacement) - (damping * velocity)
  var new_velocity = velocity + acceleration * clamped_delta  
  var new_position = pos + new_velocity * clamped_delta  

  return {
    "position": new_position,
    "velocity": new_velocity
  }
