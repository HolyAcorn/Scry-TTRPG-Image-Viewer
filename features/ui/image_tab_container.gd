class_name ImageTabContainer
extends TabContainer

const TAB_SCENE_REF : PackedScene = preload("res://features/ui/tab.tscn")

@export var new_tab_btn : Button
var tab_index : int = 0

var tabs : Array[Control]
var setup : Setup

signal tab_button_clicked(node : Tab)
signal update_setup(property_name : String, value : Variant, tab_index : int)
signal setup_loaded(setup : Setup, tab_index : int)
signal on_add_new_tab(title: String)

var setup_controller : SetupController
var slide_show : SlideShow
var load_file_dialog : LoadImageFileDialog

func build_services(setup_controller : SetupController):
	setup = setup_controller.setup
	for i in range(get_children().size()):
		var child = get_child(i)
		tabs.append(child)
		if child is Tab:
			child.on_new_name.connect(update_texts)
			child.build_services(setup_controller, i)
		elif child is Button:
			set_tab_title(i, "+")
	
func bind_services(setup_controller : SetupController, slideshow : SlideShow, load_file_dialog : LoadImageFileDialog):
	self.setup_controller = setup_controller
	self.slide_show = slideshow
	self.load_file_dialog = load_file_dialog
	for i in range(get_children().size()):
		var child = get_child(i)
		if child is Tab:
			child.bind_services(self, slide_show, load_file_dialog)
	tab_selected.connect(add_new_tab)
	setup_controller.on_setup_changed.connect(on_setup_changed)
	update_setup.connect(setup_controller.update_setup)
	on_add_new_tab.connect(setup_controller.add_tab)
	setup_loaded.connect(slideshow.update_settings)
	load_file_dialog.files_selected.connect(load_images_from_dialog)
	

func add_new_tab(tab : int):
	if tabs[tab] is not Button:
		setup_loaded.emit(setup, tab)
		tab_index = current_tab
		return
	var new_tab := TAB_SCENE_REF.instantiate() as Tab
	new_tab.build_services(setup_controller, tab-1)
	new_tab.bind_services(self, slide_show, load_file_dialog)
	new_tab.name = "Tab " + str(tab+1)
	tabs.insert(tabs.size()-1, new_tab)
	on_add_new_tab.emit(new_tab.name)
	set_tabs()

func set_tabs():
	for child in get_children():
		remove_child(child)
	for i in range(tabs.size()):
		var tab = tabs[i]
		add_child(tab)
		if tab is Button:
			set_tab_title(i, "+")
			tab_index = i
#	while current_tab != new_tab_index:
#		select_next_available()
	
func update_texts():
	for i in range(get_children().size()):
		if get_child(i).name != "+":
			var new_name = get_child(i).name
			set_tab_title(i, get_child(i).name)

func on_update_setup(property_name : String, value : Variant):
	update_setup.emit(property_name, value, current_tab)

func on_setup_changed(setup : Setup):
	tabs.clear()
	for i in range(setup.tabs.size()):
		var tab := setup.tabs[i]
		var new_tab := TAB_SCENE_REF.instantiate() as Tab
		new_tab.build_services(setup_controller, i, tab.image_paths)
		new_tab.bind_services(self, slide_show, load_file_dialog)
		new_tab.name = "Tab " + str(i+1)
		tabs.append(new_tab)
	tabs.append(new_tab_btn)
	set_tabs()
	self.setup = setup
	setup_loaded.emit(setup, current_tab)

func on_image_selected(item : Item):
	for i in range(get_children().size()):
		var tab = get_children()[i]
		if tab is Tab and i != current_tab:
			tab.on_other_tab_selected()

func load_images_from_dialog(paths : PackedStringArray):
	tabs[current_tab].item_list.load_items(paths)
