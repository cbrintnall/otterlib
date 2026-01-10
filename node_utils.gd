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
