extends Node

signal on_message(msg: String, error: bool)

class CustomLogger extends Logger:
  var on_message: Callable
  var on_error: Callable
  
  func _log_message(message: String, error: bool) -> void:
    if on_message.is_valid():
      on_message.call(message, error)

  func _log_error(
      function: String,
      file: String,
      line: int,
      code: String,
      rationale: String,
      editor_notify: bool,
      error_type: int,
      script_backtraces: Array[ScriptBacktrace]
  ) -> void:
    if on_error.is_valid():
      on_error.call()

func _init():
  var logger := CustomLogger.new()
  
  logger.on_message = on_message.emit
  
  OS.add_logger(logger)
