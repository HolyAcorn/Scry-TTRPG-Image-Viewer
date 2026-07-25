class_name InputController
extends Node

signal on_hide_button_pressed
signal on_change_image_button_pressed(next : bool)
signal on_change_tab_button_pressed(next : bool)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hide"):
		on_hide_button_pressed.emit()
	if event.is_action_pressed("ui_left"):
		on_change_image_button_pressed.emit(false)
	elif event.is_action_pressed("ui_right"):
		on_change_image_button_pressed.emit(true)
	elif event.is_action_pressed("next_tab"):
		on_change_tab_button_pressed.emit(true)
	elif event.is_action_pressed("prev_tab"):
		on_change_tab_button_pressed.emit(false)
