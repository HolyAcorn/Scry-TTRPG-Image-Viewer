class_name Tab
extends VBoxContainer

@export var options_menu : OptionsMenu
@export var item_list : ImageList
@export var add_item_btn : Button

var setup : Setup
var images : Array[String]
var index : int

signal on_new_name

func build_services(setup_controller : SetupController, tab_index : int, items : Array[String] = []):
	index = tab_index
	setup = setup_controller.setup
	options_menu.build_services(setup_controller, index)
	item_list.build_services(items)

func bind_services(tab_container : ImageTabContainer, slide_show : SlideShow, load_image_dialog : ):
	add_item_btn.pressed.connect(load_image_dialog.show_file_dialog)
	options_menu.bind_services(tab_container)
	item_list.bind_services(slide_show, tab_container)


func set_new_name(new_name: String):
	name = new_name
	on_new_name.emit()

func on_other_tab_selected():
	item_list.toggle_all_not_current()
