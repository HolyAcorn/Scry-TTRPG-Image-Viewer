class_name Tab
extends VBoxContainer

@export var options_menu : OptionsMenu
@export var item_list : ImageList
@export var add_item_btn : Button

var setup : Setup
var images : Array[Setup.ImageItem]
var index : int

signal on_new_name

func build_services(setup_controller : SetupController, tab_index : int, items : Array[Setup.ImageItem] = []):
	index = tab_index
	setup = setup_controller.setup
	options_menu.build_services(setup_controller, index)
	item_list.build_services(index, items)

func bind_services(tab_container : ImageTabContainer, slide_show : SlideShow, load_image_dialog : LoadImageFileDialog, setup_controller : SetupController ):
	add_item_btn.pressed.connect(load_image_dialog.show_file_dialog)
	options_menu.bind_services(tab_container)
	item_list.bind_services(slide_show, tab_container, setup_controller)
	#on_new_name.connect(tab_container.update_texts)

func set_new_name(new_name: String):
	name = new_name
	setup.tabs[index].title = new_name
	on_new_name.emit()

func on_other_tab_selected():
	item_list.toggle_all_not_current()
	item_list.disconnect_load_signal()

func on_tab_selected():
	item_list.connect_load_signal()
