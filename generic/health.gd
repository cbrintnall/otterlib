extends Node
class_name Health

class HealthChangeRequest:
  var owner
  var amount: int

  func _init(_owner, _amount):
    owner = _owner
    amount = _amount

signal healed(amount, current)
signal hurt(amount, current)
signal died()

@export var max_health: int:
  set(val):
    max_health = val
    current_health.max = val

var current_health := Attribute.new(0, 0, INF)
var dead := false

func _ready():
  current_health.set_value(max_health)

func modify(request: HealthChangeRequest):
  var previous = current_health.current
  current_health.incr(-request.amount)

  if previous < current_health.current:
    healed.emit(request.amount, current_health.current)
  elif previous > current_health.current:
    hurt.emit(request.amount, current_health.current)

  if not dead and current_health.current <= 0:
    dead = true
    died.emit()
