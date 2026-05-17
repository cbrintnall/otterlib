extends Node
class_name UIUtils

static func speak(label: RichTextLabel, text: String, time_per_char := 0.1, on_letter := Callable()) -> Tween:  
  label.text = text
  label.visible_characters = 0
  label.reset_size()
  
  var t = label.create_tween()
  t.tween_method(
    func(idx: int):
      var moving_on = idx > label.visible_characters
      label.visible_characters = idx
  
      if not moving_on: return
      if idx >= len(label.text): return
      
      if on_letter.is_valid():
        on_letter.call(),
    0,
    len(text),
    len(text) * time_per_char
  )
  
  return t

static func size_from(...controls: Array) -> Vector2:
  var size := Rect2()
  
  for ctrl: Control in controls:
    size = size.expand(ctrl.position)
    size = size.expand(ctrl.position+ctrl.size)
    
  return size.size

static func get_rect(ctrl: Control) -> Rect2:
  return Rect2(ctrl.position, ctrl.size)

static func is_click(event: InputEvent, index: int) -> bool:
  return event is InputEventMouseButton and event.is_pressed() and event.button_index == index
