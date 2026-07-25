class_name Main
extends Node

@export var ui : UI
@export var image_window : ImageWindow
@export var slide_show : SlideShow
@export var load_image_file_dialog : FileDialog
@export var setup_controller : SetupController

var input_controller : InputController

signal toggle_hide_image

func _ready() -> void:
	build_services()
	bind_services()

func build_services():
	input_controller = InputController.new()
	
	setup_controller.build_services()
	image_window.build_services()
	slide_show.build_services(image_window)
	ui.build_services(setup_controller)
	
func bind_services():
	setup_controller.bind_serivces()
	image_window.bind_services(self, input_controller)
	slide_show.bind_services(image_window)
	ui.bind_services(setup_controller, slide_show, load_image_file_dialog, input_controller)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hide"):
		toggle_hide_image.emit()
