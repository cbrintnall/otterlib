extends Node2D

var active := false:
  set(val):
    active = val
    _canvas.visible = active
    get_tree().paused = pause_on_open
    if val:
      _editor.grab_focus()
      clr.call_deferred()

var pause_on_open = false
var debug_font := SystemFont.new()
var debug_keys := [
  KEY_F1,
  KEY_F2,
  KEY_F3,
  KEY_F4,
  KEY_F5,
  KEY_F6,
  KEY_F7,
  KEY_F8,
  KEY_F9,
  KEY_F10,
  KEY_F11,
  KEY_F12
]

var _trackers := {}
var _commands := {}
var _cmds := {}
var _font := SystemFont.new()
var _canvas = CanvasLayer.new()
var _editor = LineEdit.new()

func register_command(str: String, callable:Callable):
  _commands[str] = callable

func register_cmd(title: String, callable: Callable):
  _cmds[debug_keys.pop_front()] = { "text": title, "callback": callable }

func get_tracker(title: String):
  if not title in _trackers:
    _trackers[title] = Attribute.new(0.0)
    Performance.add_custom_monitor(title, func(): return _trackers[title].current)
  return _trackers[title]

func _ready():
  top_level = true
  z_index = 999
  process_mode = Node.PROCESS_MODE_ALWAYS

  add_child(_canvas)
  _canvas.layer = 999
  _canvas.add_child(_editor)
  active = false

  register_command("print", func(item):
    match item:
      [var tracker, ..]:
        print(_trackers.get(tracker, Attribute.new(0.0)).current)
  )

func _process(delta):
  queue_redraw()
  _editor.size = Vector2(DisplayServer.window_get_size().x, 31)
  _editor.global_position = Vector2(0.0, DisplayServer.window_get_size().y-31)
  _editor.grow_horizontal = Control.GROW_DIRECTION_BOTH
  _editor.anchor_top = 1.0
  _editor.anchor_right = 1.0

func _draw():
  if active:
    var y := _font.get_height()
    for tracker in _trackers:
      var data = {"key": tracker, "text": _trackers[tracker].current}
      draw_string(_font, Vector2.DOWN * y, "{key}: {text}".format(data))
      y += _font.get_height()
    draw_string(_font, Vector2.DOWN * y, "---")
    y += _font.get_height()
    for cmd in _cmds:
      var data = {"key": OS.get_keycode_string(cmd), "text": _cmds[cmd]["text"]}
      draw_string(_font, Vector2.DOWN * y, "{key}: {text}".format(data))
      y += _font.get_height()

func clr():
  _editor.text =""

func _input(event):
  if event.is_action_pressed("toggle_debug"):
    active = not active

  # disgusting
  if active and "keycode" in event and event.keycode in _cmds.keys() and "pressed" in event and event.pressed:
    _cmds[event.keycode]["callback"].call()
  elif active and "keycode" in event and "pressed" in event and event.pressed and event.keycode == KEY_ENTER:
    if _editor.text:
      var cmd = _editor.text.split(" ")
      if cmd[0] in _commands.keys():
        if len(cmd) > 0:
          var cooooommand = _commands[cmd[0]] as Callable
          if cooooommand.is_valid() and not cooooommand.is_null():
            cooooommand.call(Array(cmd).slice(1))
    _editor.text = ""
