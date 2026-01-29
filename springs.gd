extends Node
class_name Springs

const MAX_DELTA = (1.0 / 60.0)

static func spring(pos, target, velocity, delta: float, stiffness: float, damping: float) -> Dictionary:
  var clamped_delta = minf(delta, MAX_DELTA)
  var displacement = pos - target  # Calculate displacement from equilibrium
  var acceleration = (-stiffness * displacement) - (damping * velocity)  # Hooke's Law + damping
  var new_velocity = velocity + acceleration * clamped_delta  # Integrate acceleration
  var new_position = pos + new_velocity * clamped_delta  # Integrate velocity

  return { "position": new_position, "velocity": new_velocity }
