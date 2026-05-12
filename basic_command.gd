extends Command
class_name BasicCommand

static func from(exec: Callable, u: Callable) -> BasicCommand:
  var cmd := BasicCommand.new()
  cmd._exec = exec
  cmd._undo = u
  return cmd

var _exec: Callable
var _undo: Callable

func execute():
  if _exec.is_valid():
    _exec.call()
  
func undo():
  if _undo.is_valid():
    _undo.call()
