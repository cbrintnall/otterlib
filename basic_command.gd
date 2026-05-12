extends Command
class_name BasicCommand

static func from(exec: Callable, u: Callable) -> BasicCommand:
  return BasicCommand.new(exec, u)

var _exec: Callable
var _undo: Callable

func _init(exec: Callable, u: Callable):
  _exec = exec
  _undo = u

func execute():
  if _exec.is_valid():
    _exec.call()
  
func undo():
  if _undo.is_valid():
    _undo.call()
