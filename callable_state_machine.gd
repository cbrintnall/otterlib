extends Node
class_name CallableStateMachine

signal state_changed(next: String)

static func noop(machine: CallableStateMachine, delta: float):
  pass

var current: String:
  set(val):
    if not (_physics_states.has(val) or _update_states.has(val)):
      print("%s tried to switch to state that doesn't exist (%s)" % [ get_path(), val ])
      print_stack()
      return
    
    if val != current:
      current = val
      time_since_state_changed = 0.0
      set_physics_process(_physics_states.has(current))
      set_process(_update_states.has(current))
      
      assert(not (is_physics_processing() and is_processing()), "Processing should be either or, not both.")
      
      state_changed.emit(current)
  get:
    return current

var time_since_state_changed := 0.0

var _physics_states := {}
var _update_states := {}

func _ready() -> void:
  set_process(false)
  set_physics_process(false)

func register(state: String, callable: Callable, physics := false):
  if physics:
    _physics_states[state] = callable
  else:
    _update_states[state] = callable
  
  if not current:
    current = state

func _process(delta: float) -> void:
  time_since_state_changed += delta
  _update_states[current].call(self, delta)

func _physics_process(delta: float) -> void:
  time_since_state_changed += delta
  _physics_states[current].call(self, delta)
