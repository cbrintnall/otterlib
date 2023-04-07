@tool
extends AnimationNodeSync
class_name AnimationNodeFilter

func _init():
  add_input("in")

func _has_filter() -> bool:
  return true

func  _get_caption():
  return "Filter"

func _process(time, seek, is_external_seeking):
  return blend_input(0, time, seek, is_external_seeking, 1.0, AnimationNode.FILTER_PASS, true)
