@tool
extends MultiMeshInstance2D
class_name BetterMultiMeshInstance2D

@export var offset: Vector2:
  set(val):
    offset = val
    _generate()

@export var jitter := Vector2.ZERO:
  set(val):
    jitter = val
    _generate()
    
@export_range(0.0, TAU, 0.01) var rotation_jitter := 0.0:
  set(val):
    rotation_jitter = val
    _generate()

@export_tool_button("Generate") var gen = Callable(_generate)

func _ready() -> void:
  if Engine.is_editor_hint():
    return

  multimesh = multimesh.duplicate()

func _generate():
  if not multimesh or not texture:
    return
  
  if not multimesh.mesh:
    multimesh.mesh = QuadMesh.new()
  multimesh.mesh.size = texture.get_size()

  var rng := RandomNumberGenerator.new()
  rng.seed = hash(String(get_path()))
  var t = Transform2D()
  for i in multimesh.instance_count:
    var ja = rng.randf_range(-jitter.x, jitter.x)
    var jb = rng.randf_range(-jitter.x, jitter.x)
    var jr = rng.randf_range(-rotation_jitter, rotation_jitter)
    var current = t.translated(Vector2(ja, jb)).rotated_local(PI).rotated_local(jr)
    multimesh.set_instance_transform_2d(i, current)
    t = t.translated(offset)

func _process(_delta: float) -> void:
  if Engine.is_editor_hint():
    return
    
  if not multimesh:
    return
    
  multimesh.visible_instance_count = mini(multimesh.visible_instance_count, multimesh.instance_count)
