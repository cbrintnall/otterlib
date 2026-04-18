extends Node2D
class_name Stretcher

@export var stiffness := 500.0
@export var damping := 10.0

var stretch: float:
  set(val):
    _stretch = val
  get:
    return _stretch

var _stretch := 0.0

func punch(low := 0.1, high := 0.3):
  Springer.data[self]["_stretch"]["velocity"] = randf_range(low, high)

func _ready() -> void:
  Springer.register("_stretch", self, 0.0, 0.0, stiffness, damping)

func _process(_delta: float) -> void:
  scale = Vector2(1.0+_stretch, 1.0-_stretch)
