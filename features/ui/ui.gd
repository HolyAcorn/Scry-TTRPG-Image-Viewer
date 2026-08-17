class_name UI
extends Control

@export var tab_container : ImageTabContainer
@export var save_setup_btn : Button
@export var load_setup_btn : Button
@export var start_slideshow_btn : Button
@export var rename_tab_container : RenameTabContainer

func build_services(setup_controller : SetupController):
	tab_container.build_services(setup_controller)
	
func bind_services(setup_controller : SetupController, slideshow : SlideShow, load_file_dialog : LoadImageFileDialog):
	save_setup_btn.pressed.connect(setup_controller.show_save_setup)
	load_setup_btn.pressed.connect(setup_controller.show_load_setup)
	start_slideshow_btn.pressed.connect(slideshow.on_slideshow)
	slideshow.toggle_slideshow_btn_disabled.connect(toggle_slideshow_button_disabled)
	slideshow.set_slideshow_btn_text.connect(set_slideshow_button_text)
	tab_container.bind_services(setup_controller, slideshow, load_file_dialog)
	rename_tab_container.bind_services(tab_container)

func toggle_slideshow_button_disabled(disabled : bool):
	start_slideshow_btn.disabled = disabled

func set_slideshow_button_text(text : String):
	start_slideshow_btn.text = text
