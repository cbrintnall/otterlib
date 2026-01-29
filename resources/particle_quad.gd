@tool
extends QuadMesh
class_name ParticleQuadMesh

func _init():
  material = StandardMaterial3D.new()
  
  material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
  material.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
  material.billboard_keep_scale = true
  material.grow = true
  material.vertex_color_use_as_albedo = true
