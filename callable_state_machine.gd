extends Node
class_name CallableStateMachine

var current: String:
  set(val):
    if val != current:
      current = val
      set_physics_process(_physics_states.has(current))
      set_process(_update_states.has(current))
  get:
    return current

var _physics_states := {}
var _update_states := {}

func _ready() -> void:
  set_process(false)
  set_physics_process(false)

func register(state: String, callable: Callable, physics := false):
  if physics:
    _physics_states[state] = callable
    if not current:
      current = state
  else:
    _update_states[state] = callable
    if not current:
      current = state

func _process(delta: float) -> void:
  _update_states[current].call(self, delta)

func _physics_process(delta: float) -> void:
  _physics_states[current].call(self, delta)
