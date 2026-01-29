@tool
extends EditorScript
class_name BaseCreateScript

"""
Extend to get a command that pops up text, upon hitting enter
it will run _on_text_input and pass in the text that was provided.

A quick and easy way to create resources at a specific path or something.
"""

func _run() -> void:
  var dialog := AcceptDialog.new()
  dialog.title = "Input"
  dialog.min_size = Vector2(300, 80)

  var line_edit := LineEdit.new()
  line_edit.placeholder_text = "Enter text..."
  line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL

  dialog.add_child(line_edit)

  var editor_ui := EditorInterface.get_base_control()
  editor_ui.add_child(dialog)

  dialog.popup_centered()
  line_edit.grab_focus()

  line_edit.text_submitted.connect(func(text: String):
    dialog.queue_free()
    _on_text_input(text)
  )

func _on_text_input(text: String) -> void:
  pass
