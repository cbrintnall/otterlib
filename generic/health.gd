extends Node
class_name Health

class HealthChangeRequest:
  var owner
  var amount: int

  func _init(_owner, _amount):
    owner = _owner
    amount = _amount

class HealthChangedResult:
  var request: HealthChangeRequest
  var before: int
  var after: int
  var amount_modified: int

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

  var result = HealthChangedResult.new()

  result.request = request
  result.before = previous
  result.after = current_health.current
  result.amount_modified = previous-current_health.current

  if previous < current_health.current:
    healed.emit(result)
  elif previous > current_health.current:
    hurt.emit(result)

  if not dead and current_health.current <= 0:
    dead = true
    died.emit()
