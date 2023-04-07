@tool
extends MeshInstance3D
class_name Line3D

@export var material: ORMMaterial3D:
  set(val):
    material = val
    _update_points()
  get:
    return material

@export var points: Array[Vector3]:
  set(val):
    points = val
    _update_points()
  get:
    return points

func _update_points():
  var i = mesh as ImmediateMesh

  i.clear_surfaces()
  i.surface_begin(Mesh.PRIMITIVE_LINES, material)
  for pt in points:
    i.surface_add_vertex(pt)
  i.surface_end()

  print("points updated")

func _process(delta):
  if Engine.is_editor_hint():
    _update_points()
