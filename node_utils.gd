extends Node
class_name NodeUtils

static func iterate_nodes(root: Node, cb: Callable):
  cb.call(root)
  for child in root.get_children():
    iterate_nodes(child, cb)

static func get_nodes_with_predicate(root: Node, predicate: Callable) -> Array:
  var passed := []
  if predicate.call(root):
    passed.push_back(root)
  for child in root.get_children():
    passed.append_array(get_nodes_with_predicate(child, predicate))
  return passed

static func clear_children(root: Node):
  for child in root.get_children():
    child.queue_free()

static func force_child(parent: Node, child: Node):
  if child.get_parent()==null:
    parent.add_child(child)
  elif child.get_parent()!=parent:
    child.reparent(parent)

static func find_child_with_predicate(root: Node, predicate: Callable) -> Node:
  if predicate.call(root):
    return root
    
  for child in root.get_children():
    return find_child_with_predicate(child, predicate)
    
  return null

static func is_hovered(ctrl: Control) -> bool:
  return ctrl.get_viewport().gui_get_hovered_control() == ctrl
  
static func is_mouse_inside(ctrl: Control) -> bool:
  return ctrl.get_global_rect().has_point(ctrl.get_global_mouse_position())

static func free_on_finished(particles, start := true):
  particles.one_shot = true
  assert(particles.one_shot, "Finished signal doesn't fire unless particles are one-shot")
  particles.finished.connect(particles.queue_free)
  particles.emitting = start
  return particles

static func free_on_finished_2d(particles: GPUParticles2D, start := true):
  particles.one_shot = true
  assert(particles.one_shot, "Finished signal doesn't fire unless particles are one-shot")
  particles.finished.connect(particles.queue_free)
  particles.emitting = start
  return particles

static func fire_particles_at(owner, particles):
  NodeUtils.force_child(owner.get_parent(), particles)
  particles.global_position = owner.global_position
  NodeUtils.free_on_finished(particles)
  return particles
  
static func collect_children_in_group(parent: Node, group: StringName) -> Array:
  return get_nodes_with_predicate(parent, func(node: Node): return node.is_in_group(group))

static func collect_children(parent: Node, ...names) -> Dictionary:
  var children := {}
  
  for arg: String in names:
    var key = arg
    children[key] = parent.find_child(arg)

  return children

static func get_normalized_time(timer: Timer) -> float:
  return timer.time_left/timer.wait_time
