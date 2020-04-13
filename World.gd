extends Node

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed('ui_cancel'):
		get_tree().quit(0)

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit(0)
