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
  
static func is_mouse_inside(ctrl: Control, vp: Viewport) -> bool:
  return ctrl.get_global_rect().has_point(vp.get_mouse_position())

static func free_on_finished(particles: GPUParticles3D, start: bool):
  assert(particles.one_shot, "Finished signal doesn't fire unless particles are one-shot")
  particles.finished.connect(particles.queue_free)
  particles.emitting = start
